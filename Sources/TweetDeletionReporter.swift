//
//  TweetDeletionReporter.swift
//  Rehatch
//
//  Created by David Roman on 06/07/2017.
//
//

import Foundation

final class TweetDeletionReporter {

	let totalTweets: Int
	var succeededTweets = [Tweet]()
	var failedTweets = [Tweet]()
	let elapsedTime = TimeInterval(0)

	init(totalTweets: Int) {
		self.totalTweets = totalTweets
	}

	func report(_ tweet: Tweet, success: Bool) {
		if success {
			succeededTweets.append(tweet)
		} else {
			failedTweets.append(tweet)
		}
		printProgress()
		endReportIfPossible()
	}

	func printProgress() {
//		print("\027[k")
	}

	func endReportIfPossible() {
		let tweetCount = succeededTweets.count + failedTweets.count

		guard tweetCount >= totalTweets else {
			return
		}

		// Print
	}
}
