//
//  Tweet.swift
//  Rehatch
//
//  Created by David Román Aguirre on 23/01/2017.
//
//

import Foundation

struct Tweet {
	let id: String
	let date: Date
	let isRetweet: Bool
}

extension Array where Element == Tweet {
	func sortedTweets(until date: Date) -> [Tweet] {
		return self
			.filter { $0.date < date }
			.sorted { $0.date < $1.date }
	}
}
