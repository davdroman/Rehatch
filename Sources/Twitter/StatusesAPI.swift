import Foundation
import OhhAuth
import Sugar

public struct ConsumerKey {
	public var key: String
	public var secret: String

	public init(key: String, secret: String) {
		self.key = key
		self.secret = secret
	}
}

public final class StatusesAPI {
	let consumerKey: ConsumerKey
	let accessToken: OAuth.AccessToken

	public init(consumerKey: ConsumerKey, accessToken: OAuth.AccessToken) {
		self.consumerKey = consumerKey
		self.accessToken = accessToken
	}

	public func unretweetTweet(with tweetId: String) throws {
		try performAction("unretweet", tweetId: tweetId)
	}

	public func deleteTweet(with tweetId: String) throws {
		try performAction("destroy", tweetId: tweetId)
	}

	func performAction(_ action: String, tweetId: String) throws {
		let url = try URL(
			scheme: "https",
			host: "api.twitter.com",
			path: "/1.1/statuses/\(action)/\(tweetId).json"
		)
		var request = URLRequest(url: url)
		request.oAuthSign(
			method: "POST",
			urlFormParameters: [:],
			consumerCredentials: (key: consumerKey.key, secret: consumerKey.secret),
			userCredentials: (key: accessToken.token, secret: accessToken.secret)
		)

		let result = try URLSession(configuration: .ephemeral).synchronousDataTask(with: request).get()
		guard let response = result.response as? HTTPURLResponse else {
			fatalError("Impossible!")
		}

		switch response.statusCode {
		case 200...299:
			break
		default:
			throw Error.http(statusCode: response.statusCode)
		}
	}
}

extension StatusesAPI {
	public enum Error: Swift.Error {
		case http(statusCode: Int)
	}
}
