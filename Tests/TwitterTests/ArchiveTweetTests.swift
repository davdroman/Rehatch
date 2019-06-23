import XCTest
@testable import Twitter

final class ArchiveTweetTests: XCTestCase {
	var rawTweets: [Archive.Tweet] {
		return [
			Archive.Tweet(id: "B", date: Date(timeIntervalSince1970: 200), isRetweet: true),
			Archive.Tweet(id: "D", date: Date(timeIntervalSince1970: 400), isRetweet: true),
			Archive.Tweet(id: "E", date: Date(timeIntervalSince1970: 500), isRetweet: true),
			Archive.Tweet(id: "C", date: Date(timeIntervalSince1970: 300), isRetweet: true),
			Archive.Tweet(id: "A", date: Date(timeIntervalSince1970: 100), isRetweet: true),
		]
	}

	func testSortedTweetsUntilDate_EarlyDate() {
		let date = Date(timeIntervalSince1970: 50)
		let sortedTweets = rawTweets.sortedTweets(until: date)
		XCTAssertTrue(sortedTweets.isEmpty)
	}

	func testSortedTweetsUntilDate_MiddleDate() {
		let date = Date(timeIntervalSince1970: 250)
		let sortedTweets = rawTweets.sortedTweets(until: date)
		XCTAssertEqual(sortedTweets.count, 2)
		XCTAssertEqual(sortedTweets.map({ $0.id }), ["A", "B"])
	}

	func testSortedTweetsUntilDate_LateDate() {
		let date = Date(timeIntervalSince1970: 600)
		let sortedTweets = rawTweets.sortedTweets(until: date)
		XCTAssertEqual(sortedTweets.count, 5)
		XCTAssertEqual(sortedTweets.map({ $0.id }), ["A", "B", "C", "D", "E"])
	}
}
