//
//  TweetParser.swift
//  Rehatch
//
//  Created by David Román Aguirre on 23/01/2017.
//
//

import Foundation
import Result
import CSV

struct TweetParser {

	enum Error: Swift.Error {
		case csv
		case date(dateString: String)
	}

	let path: String

	init(path: String) {
		if path.hasSuffix("/") {
			self.path = path + "tweets.csv"
		} else {
			self.path = path + "/tweets.csv"
		}
	}

	func parse() -> Result<[Tweet], Error> {
		guard let stream = InputStream(fileAtPath: path) else {
			return .failure(.csv)
		}

		var tweets = [Tweet]()

		do {
			for (index, line) in try CSV(stream: stream).enumerated() {
				if index > 0 && line.count > 6 {
					let id = line[0]
					let timestamp = line[3]
					let isRetweet = !line[6].isEmpty

					let dateFormatter = DateFormatter()
					dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

					if let date = dateFormatter.date(from: timestamp) {
						let tweet = Tweet(id: id, date: date, isRetweet: isRetweet)
						tweets.append(tweet)
					}
				}
			}
		} catch {
			return .failure(.csv)
		}

		return .success(tweets)
	}
}
