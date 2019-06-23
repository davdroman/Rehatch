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
		#if DEBUG
		sleep(2)
		#else
		let url = try URL(
			scheme: "https",
			host: "api.twitter.com",
			path: "/1.1/statuses/unretweet/\(tweetId).json"
		)
		var request = URLRequest(url: url)
		request.oAuthSign(
			method: "POST",
			urlFormParameters: [:],
			consumerCredentials: (key: consumerKey.key, secret: consumerKey.secret),
			userCredentials: (key: accessToken.token, secret: accessToken.secret)
		)

		_ = try URLSession(configuration: .ephemeral).synchronousDataTask(with: request).get()
		#endif
	}

	public func deleteTweet(with tweetId: String) throws {
		#if DEBUG
		sleep(2)
		#else
		let url = try URL(
			scheme: "https",
			host: "api.twitter.com",
			path: "/1.1/statuses/destroy/\(tweetId).json"
		)
		var request = URLRequest(url: url)
		request.oAuthSign(
			method: "POST",
			urlFormParameters: [:],
			consumerCredentials: (key: consumerKey.key, secret: consumerKey.secret),
			userCredentials: (key: accessToken.token, secret: accessToken.secret)
		)

		_ = try URLSession(configuration: .ephemeral).synchronousDataTask(with: request).get()
		#endif
	}
}
