//
//  TwitterAPI.swift
//  Rehatch
//
//  Created by David Román Aguirre on 23/01/2017.
//
//

import Foundation
//import OhhAuth

public protocol TwitterAPIProtocol {
	init(consumerKey: String, consumerSecret: String, accessToken: String, accessTokenSecret: String)
	func deleteTweet(_ tweet: Tweet, completion: @escaping ((Result<Tweet, Error>) -> Void))
}

public final class TwitterAPI: TwitterAPIProtocol {

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
//		let action = tweet.isRetweet ? "unretweet" : "destroy"
//
//		var request = URLRequest(url: URL(string: "https://api.twitter.com/1.1/statuses/\(action)/\(tweet.id).json")!)
//		request.oAuthSign(
//			method: "POST",
//			urlFormParameters: [:],
//			consumerCredentials: (key: consumerKey, secret: consumerSecret),
//			userCredentials: (key: accessToken, secret: accessTokenSecret)
//		)
//
//		let task = URLSession(configuration: .ephemeral).dataTask(with: request) { (data, response, error) in
//			if let error = error {
//				completion(.failure(AnyError(error)))
//			} else if data != nil {
//				completion(.success(tweet))
//			}
//		}
//
//		task.resume()
	}
}
