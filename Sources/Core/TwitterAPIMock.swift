import Foundation

public final class TwitterAPIMock: TwitterAPIProtocol {

	let consumerKey: String
	let consumerSecret: String
	let accessToken: String
	let accessTokenSecret: String

	public init(consumerKey: String, consumerSecret: String, accessToken: String, accessTokenSecret: String) {
		self.consumerKey = consumerKey
		self.consumerSecret = consumerSecret
		self.accessToken = accessToken
		self.accessTokenSecret = accessTokenSecret
	}

	public func deleteTweet(_ tweet: Tweet, completion: @escaping ((Result<Tweet, Error>) -> Void)) {
		DispatchQueue.global(qos: .background).async {
			sleep(1)
			completion(.success(tweet))
		}
	}
}
