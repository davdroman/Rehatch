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
		echoProgress(current: succeededTweets.count + failedTweets.count, total: totalTweets)
		endReportIfPossible()
	}

	var progressString: String {
		if let percentageString = percentageString {
			return "Done! \(succeededTweets.count)/\(totalTweets) were deleted. That's \(percentageString) of your tweets."
		} else {
			return "Done! \(succeededTweets.count)/\(totalTweets) were deleted."
		}
	}

	var percentageString: String? {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .percent
		numberFormatter.minimumFractionDigits = 0
		numberFormatter.maximumFractionDigits = 2
		numberFormatter.roundingMode = .floor
		return numberFormatter.string(from: NSNumber(value: successPercentage))
	}

	var successPercentage: Double {
		return Double(succeededTweets.count) / Double(totalTweets)
	}

	private func endReportIfPossible() {
		let tweetCount = succeededTweets.count + failedTweets.count

		guard tweetCount >= totalTweets else {
			return
		}

		print(progressString)
	}
}
