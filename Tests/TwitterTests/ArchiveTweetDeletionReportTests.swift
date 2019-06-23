import XCTest
@testable import Twitter

final class ArchiveTweetDeletionReportTests: XCTestCase {
	func testReportSuccessAddsTweetToCollection() {
		let reporter = Archive.Tweet.DeletionReport(totalTweets: 5)
		XCTAssertTrue(reporter.succeededTweets.isEmpty)
		XCTAssertTrue(reporter.failedTweets.isEmpty)
		reporter.add(
			Archive.Tweet(id: "A", date: Date(), isRetweet: true),
			success: true
		)
		XCTAssertEqual(reporter.succeededTweets.count, 1)
		XCTAssertTrue(reporter.failedTweets.isEmpty)
	}

	func testReportFailureAddsTweetToCollection() {
		let reporter = Archive.Tweet.DeletionReport(totalTweets: 5)
		XCTAssertTrue(reporter.succeededTweets.isEmpty)
		XCTAssertTrue(reporter.failedTweets.isEmpty)
		reporter.add(
			Archive.Tweet(id: "A", date: Date(), isRetweet: true),
			success: false
		)
		XCTAssertTrue(reporter.succeededTweets.isEmpty)
		XCTAssertEqual(reporter.failedTweets.count, 1)
	}

	func testReportPercentageString() {
		let reporter = Archive.Tweet.DeletionReport(totalTweets: 3)
		XCTAssertEqual(reporter.progressString, "Deleting tweets (0/3)")
		
		reporter.add(
			Archive.Tweet(id: "A", date: Date(), isRetweet: true),
			success: true
		)
		XCTAssertEqual(reporter.progressString, "Deleting tweets (1/3)")

		reporter.add(
			Archive.Tweet(id: "B", date: Date(), isRetweet: true),
			success: true
		)
		XCTAssertEqual(reporter.progressString, "Deleting tweets (2/3)")

		reporter.add(
			Archive.Tweet(id: "C", date: Date(), isRetweet: true),
			success: true
		)
		XCTAssertEqual(reporter.progressString, "Deleting tweets (3/3)")
	}
}
