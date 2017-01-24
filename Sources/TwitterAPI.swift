//
//  TwitterAPI.swift
//  Rehatch
//
//  Created by David Román Aguirre on 23/01/2017.
//
//

import Foundation
import Swifter

typealias VoidClosure<T> = (T) -> Void

final class TwitterAPI {

	private let swifter: Swifter

	init(consumerKey: String, consumerSecret: String) {
		self.swifter = Swifter(consumerKey: consumerKey, consumerSecret: consumerSecret)
	}

	func deleteTweet(_ tweet: Tweet, completion: VoidClosure<Error?>?) {
		let deleteTweet = tweet.isRetweet ? swifter.UnretweetTweet : swifter.destroyTweet

		deleteTweet(tweet.id, nil, { _ in
			print("Tweet \(tweet.id) deleted")
			completion?(nil)
		}, { error in
			print("Could not delete tweet \(tweet.id)")
			completion?(error)
		})
	}

	func deleteTweets(_ tweets: [Tweet], completion: VoidClosure<Void>?) {
		let totalTweets = tweets.count
		var elapsedTweets = 0
		var deletedTweets = 0

		for tweet in tweets {
			deleteTweet(tweet) { error in
				elapsedTweets += 1

				if error == nil {
					deletedTweets += 1
				}

				if elapsedTweets >= totalTweets {
					let percentage = (Double(deletedTweets)/Double(totalTweets))*100
					print("Done! \(deletedTweets)/\(totalTweets) were deleted. That's \(percentage)% of your tweets.")
					completion?()
				}
			}
		}
	}
}
