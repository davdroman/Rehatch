import Foundation
import CSV

public struct Archive {
	public struct Tweet: Decodable {
		public let id: String
		public let date: Date
		public let isRetweet: Bool

		enum CodingKeys: String, CodingKey {
			case id = "tweet_id"
			case date = "timestamp"
			case isRetweet = "retweeted_status_id"
		}

		public init(id: String, date: Date, isRetweet: Bool) {
			self.id = id
			self.date = date
			self.isRetweet = isRetweet
		}

		public init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.id = try container.decode(String.self, forKey: .id)
			self.date = try container.decode(Date.self, forKey: .date)
			self.isRetweet = try container.decodeIfPresent(String.self, forKey: .isRetweet) != nil
		}
	}

	public var tweets: [Tweet]

	public init(contentsOfFolder path: String) throws {
		let tweetsCSVFilePathURL = URL(fileURLWithPath: path).appendingPathComponent("tweets.csv")
		let csvData = try Data(contentsOf: tweetsCSVFilePathURL)
		let csvString = String(data: csvData, encoding: .utf8)!

		var tweets = [Tweet]()
		let reader = try CSVReader(string: csvString, hasHeaderRow: true)
		let decoder = CSVRowDecoder()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		while reader.next() != nil {
			let row = try decoder.decode(Tweet.self, from: reader)
			tweets.append(row)
		}
		self.tweets = tweets
	}
}

extension Archive.Tweet {
	public final class DeletionReport {
		let totalTweets: Int
		var succeededTweets = [Archive.Tweet]()
		var failedTweets = [Archive.Tweet]()

		public init(totalTweets: Int) {
			self.totalTweets = totalTweets
		}

		public func add(_ tweet: Archive.Tweet, success: Bool) {
			if success {
				succeededTweets.append(tweet)
			} else {
				failedTweets.append(tweet)
			}
		}

		public var progressString: String {
			return "Deleting tweets (\(succeededTweets.count)/\(totalTweets))"
		}

		public var endString: String {
			if successPercentage == 1 {
				return "Done! All your tweets were deleted."
			} else {
				return "Done! \(succeededTweets.count)/\(totalTweets) tweets were deleted."
			}
		}

		var successPercentage: Double {
			return Double(succeededTweets.count) / Double(totalTweets)
		}

		public var didFinish: Bool {
			let tweetCount = succeededTweets.count + failedTweets.count
			return tweetCount >= totalTweets
		}
	}
}

extension Array where Element == Archive.Tweet {
	public func sortedTweets(until date: Date) -> [Element] {
		return self
			.filter { $0.date < date }
			.sorted { $0.date < $1.date }
	}
}
