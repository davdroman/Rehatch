//
//  TweetDeletionReporter.swift
//  Rehatch
//
//  Created by David Roman on 06/07/2017.
//
//

import Foundation

public final class TweetDeletionReporter {

//	public let totalTweets: Int
//	var succeededTweets = [Tweet]()
//	var failedTweets = [Tweet]()
//
//	public init(totalTweets: Int) {
//		self.totalTweets = totalTweets
//	}
//
//	public func report(_ tweet: Tweet, success: Bool) {
//		if success {
//			succeededTweets.append(tweet)
//		} else {
//			failedTweets.append(tweet)
//		}
//		echoProgress(current: succeededTweets.count + failedTweets.count, total: totalTweets)
//		endReportIfPossible()
//	}
//
//	var progressString: String {
//		if successPercentage == 1 {
//			return "Done! All your tweets were deleted."
//		} else if let percentageString = percentageString {
//			return "Done! \(succeededTweets.count)/\(totalTweets) tweets were deleted. That's \(percentageString) of your tweets."
//		} else {
//			return "Done! \(succeededTweets.count)/\(totalTweets) tweets were deleted."
//		}
//	}
//
//	var percentageString: String? {
//		let numberFormatter = NumberFormatter()
//		numberFormatter.numberStyle = .percent
//		numberFormatter.minimumFractionDigits = 0
//		numberFormatter.maximumFractionDigits = 2
//		numberFormatter.roundingMode = .floor
//		return numberFormatter.string(from: NSNumber(value: successPercentage))
//	}
//
//	var successPercentage: Double {
//		return Double(succeededTweets.count) / Double(totalTweets)
//	}
//
//	private func endReportIfPossible() {
//		let tweetCount = succeededTweets.count + failedTweets.count
//
//		guard tweetCount >= totalTweets else {
//			return
//		}
//
//		echoNewline()
//		print(progressString)
//	}
}
