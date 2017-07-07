//
//  TwitterAPI.swift
//  Rehatch
//
//  Created by David Román Aguirre on 23/01/2017.
//
//

import Foundation
import Result
import Swifter

public protocol TwitterAPIProtocol {
	init(consumerKey: String, consumerSecret: String, accessToken: String, accessTokenSecret: String)
	func deleteTweet(_ tweet: Tweet, completion: @escaping ((Result<Tweet, AnyError>) -> Void))
}

public final class TwitterAPI: TwitterAPIProtocol {

	private let swifter: Swifter

	public init(consumerKey: String, consumerSecret: String, accessToken: String, accessTokenSecret: String) {
		swifter = Swifter(
			consumerKey: consumerKey,
			consumerSecret: consumerSecret,
			oauthToken: accessToken,
			oauthTokenSecret: accessTokenSecret
		)
	}

	public func deleteTweet(_ tweet: Tweet, completion: @escaping ((Result<Tweet, AnyError>) -> Void)) {
		let deleteTweetClosure = tweet.isRetweet ? swifter.UnretweetTweet : swifter.destroyTweet

		deleteTweetClosure(tweet.id, nil, { _ in
			completion(.success(tweet))
		}, { error in
			completion(.failure(AnyError(error)))
		})
	}
}
