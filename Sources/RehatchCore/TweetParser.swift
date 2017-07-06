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

	private enum Constants {
		static let tweetsFilename = "tweets.csv"
		static let dateFormat = "yyyy-MM-dd HH:mm:ss Z"
	}

	enum Error: Swift.Error {
		case path
		case format
		case empty
		case parsing
	}

	func parse(fromArchive url: URL) -> Result<[Tweet], Error> {
		let csvURL = url.appendingPathComponent(Constants.tweetsFilename)

		guard let stream = InputStream(url: csvURL) else {
			return .failure(.path)
		}

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = Constants.dateFormat

		do {
			let csv = try CSV(stream: stream)

			guard Array(csv).count <= 1 else {
				return .failure(.empty)
			}

			let tweets = csv
				.enumerated()
				.filter { index, _ in index > 0 }
				.flatMap { _, line -> Tweet? in
					guard
						let id = line[safe: 0],
						let date = line[safe: 3].flatMap(dateFormatter.date),
						let isRetweet = line[safe: 6].map({ !$0.isEmpty })
					else {
						return nil
					}

					return Tweet(id: id, date: date, isRetweet: isRetweet)
				}

			guard !tweets.isEmpty else {
				return .failure(.parsing)
			}

			return .success(tweets)
		} catch {
			return .failure(.format)
		}
	}
}
