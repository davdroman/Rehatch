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

final class TwitterAPI {

	private let swifter: Swifter

	init(consumerKey: String, consumerSecret: String, accessToken: String, accessTokenSecret: String) {
		swifter = Swifter(
			consumerKey: consumerKey,
			consumerSecret: consumerSecret,
			oauthToken: accessToken,
			oauthTokenSecret: accessTokenSecret
		)
	}

	func deleteTweet(_ tweet: Tweet, completion: @escaping ((Result<Tweet, AnyError>) -> Void)) {
		let deleteTweetClosure = tweet.isRetweet ? swifter.UnretweetTweet : swifter.destroyTweet

		deleteTweetClosure(tweet.id, nil, { _ in
//			print("Tweet \(tweet.id) deleted")
			completion(.success(tweet))
		}, { error in
//			print("Could not delete tweet \(tweet.id)")
			completion(.failure(AnyError(error)))
		})
	}
}
