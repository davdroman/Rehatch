import Foundation
import OhhAuth
import Sugar
import ShellOut
import Swifter

public enum OAuth {
	public struct RequestToken: Codable {
		var token: String
		var secret: String
		var isCallbackConfirmed: Bool

		enum CodingKeys: String, CodingKey {
			case token = "oauth_token"
			case secret = "oauth_token_secret"
			case isCallbackConfirmed = "oauth_callback_confirmed"
		}
	}

	public struct AuthorizationResponse: Codable {
		var token: String
		var verifier: String
	}

	public struct AccessToken: Codable {
		var token: String
		var secret: String
		var userId: String
		public var username: String

		enum CodingKeys: String, CodingKey {
			case token = "oauth_token"
			case secret = "oauth_token_secret"
			case userId = "user_id"
			case username = "screen_name"
		}
	}

	public final class API {
		let consumerKey: ConsumerKey

		public init(consumerKey: ConsumerKey) {
			self.consumerKey = consumerKey
		}

		public func requestToken() throws -> RequestToken {
			let url = try URL(
				scheme: "https",
				host: "api.twitter.com",
				path: "/oauth/request_token"
			)
			var request = URLRequest(url: url)
			request.oAuthSign(
				method: "POST",
				urlFormParameters: ["oauth_callback": "http://localhost:8080"],
				consumerCredentials: (
					key: consumerKey.key,
					secret: consumerKey.secret
				)
			)

			let session = URLSession(configuration: .ephemeral)
			let result = try session.synchronousDataTask(with: request).get()
			guard let response = result.response as? HTTPURLResponse else {
				fatalError("Impossible!")
			}

			switch response.statusCode {
			case 200...299:
				break
			default:
				let error = try? JSONDecoder().decode(TwitterError.self, from: result.data)
				throw Error.http(statusCode: response.statusCode, twitterError: error)
			}

			guard let queryParams = String(data: result.data, encoding: .utf8) else {
				throw Error.responseParsingError
			}

			return try RequestToken(rawQueryParamsValue: queryParams)
		}

		public func authorize(with requestToken: RequestToken) throws -> AuthorizationResponse {
			let url = try URL(
				scheme: "https",
				host: "api.twitter.com",
				path: "/oauth/authorize",
				queryItems: [URLQueryItem(name: RequestToken.CodingKeys.token.rawValue, value: requestToken.token)]
			)

			_ = try shellOut(to: "open '\(url.absoluteURL)'")

			var possibleCallbackParams: [(String, String)]?

			let semaphore = DispatchSemaphore(value: 0)
			let server = HttpServer()
			server["/"] = { request in
				possibleCallbackParams = request.queryParams
				semaphore.signal()
				return .ok(.htmlBody("Success! You can now close this page and go back to your terminal."))
			}
			try server.start(8080)
			semaphore.wait()
			guard
				let callbackParams = possibleCallbackParams,
				let token = callbackParams.first(where: { $0.0 == "oauth_token" })?.1,
				let verifier = callbackParams.first(where: { $0.0 == "oauth_verifier" })?.1
			else {
				fatalError("http://localhost:8080 callback url was accessed without required query params")
			}

			return AuthorizationResponse(token: token, verifier: verifier)
		}

		public func exchangeRequestTokenForAccessToken(with requestToken: RequestToken, authorizationResponse: AuthorizationResponse) throws -> AccessToken {
			let url = try URL(
				scheme: "https",
				host: "api.twitter.com",
				path: "/oauth/access_token",
				queryItems: [URLQueryItem.init(name: "oauth_verifier", value: authorizationResponse.verifier)]
			)
			var request = URLRequest(url: url)
			request.oAuthSign(
				method: "POST",
				urlFormParameters: ["oauth_token": authorizationResponse.token],
				consumerCredentials: (
					key: consumerKey.key,
					secret: consumerKey.secret
				)
			)

			let session = URLSession(configuration: .ephemeral)
			let result = try session.synchronousDataTask(with: request).get()
			guard let response = result.response as? HTTPURLResponse else {
				fatalError("Impossible!")
			}

			switch response.statusCode {
			case 200...299:
				break
			default:
				let error = try? JSONDecoder().decode(TwitterError.self, from: result.data)
				throw Error.http(statusCode: response.statusCode, twitterError: error)
			}

			guard let queryParams = String(data: result.data, encoding: .utf8) else {
				throw Error.responseParsingError
			}

			return try AccessToken(rawQueryParamsValue: queryParams)
		}
	}
}

extension OAuth.RequestToken {
	init(rawQueryParamsValue rawValue: String) throws {
		let parsedQueryParams = rawValue
			.components(separatedBy: "&")
			.compactMap { param -> (key: String, value: String)? in
				let components = param.components(separatedBy: "=")
				switch (components.first, components.dropFirst().first) {
				case let (key?, value?):
					return (key: key, value: value)
				default:
					return nil
				}
			}

		guard
			let token = parsedQueryParams.first(where: { $0.key == CodingKeys.token.rawValue })?.value,
			let secret = parsedQueryParams.first(where: { $0.key == CodingKeys.secret.rawValue })?.value,
			let rawIsCallbackConfirmed = parsedQueryParams.first(where: { $0.key == CodingKeys.isCallbackConfirmed.rawValue })?.value,
			let isCallbackConfirmed = Bool(rawIsCallbackConfirmed)
		else {
			throw Error.invalidRawQueryParamsValue
		}

		self.init(token: token, secret: secret, isCallbackConfirmed: isCallbackConfirmed)
	}

	public enum Error: Swift.Error {
		case invalidRawQueryParamsValue
	}
}

extension OAuth.AccessToken {
	init(rawQueryParamsValue rawValue: String) throws {
		let parsedQueryParams = rawValue
			.components(separatedBy: "&")
			.compactMap { param -> (key: String, value: String)? in
				let components = param.components(separatedBy: "=")
				switch (components.first, components.dropFirst().first) {
				case let (key?, value?):
					return (key: key, value: value)
				default:
					return nil
				}
		}

		guard
			let token = parsedQueryParams.first(where: { $0.key == CodingKeys.token.rawValue })?.value,
			let secret = parsedQueryParams.first(where: { $0.key == CodingKeys.secret.rawValue })?.value,
			let userId = parsedQueryParams.first(where: { $0.key == CodingKeys.userId.rawValue })?.value,
			let username = parsedQueryParams.first(where: { $0.key == CodingKeys.username.rawValue })?.value
		else {
			throw Error.invalidRawQueryParamsValue
		}

		self.init(token: token, secret: secret, userId: userId, username: username)
	}

	public enum Error: Swift.Error {
		case invalidRawQueryParamsValue
	}
}

extension OAuth.API {
	public struct TwitterError: Codable {

	}

	public enum Error: Swift.Error {
		case responseParsingError
		case http(statusCode: Int, twitterError: TwitterError?)
	}
}
