//
//  TweetParser.swift
//  Rehatch
//
//  Created by David Román Aguirre on 23/01/2017.
//
//

import Foundation
import CSV

struct TweetParser {

	enum Error: Swift.Error {
		case something
	}

	let path: String

	init(path: String) {
		if path.hasSuffix("/") {
			self.path = path + "tweets.csv"
		} else {
			self.path = path + "/tweets.csv"
		}
	}

	func parse() throws -> [Tweet] {
		guard let stream = InputStream(fileAtPath: path) else {
			throw Error.something
		}

		var tweets = [Tweet]()

		do {
			for (index, line) in try CSV(stream: stream).enumerated() {
				if index > 0 && line.count >= 3 {
					let id = line[0]
					let timestamp = line[3]

					let dateFormatter = DateFormatter()
					dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

					guard let date = dateFormatter.date(from: timestamp) else {
						throw Error.something
					}

					let tweet = Tweet(id: id, date: date)
					tweets.append(tweet)
				}
			}
		} catch {
			throw Error.something
		}

		return tweets
	}
}
