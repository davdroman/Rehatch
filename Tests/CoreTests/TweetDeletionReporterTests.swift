import XCTest
@testable import RehatchCore

final class TweetDeletionReporterTests: XCTestCase {

	func testReportSuccessAddsTweetToCollection() {
		let reporter = TweetDeletionReporter(totalTweets: 5)
		XCTAssertTrue(reporter.succeededTweets.isEmpty)
		XCTAssertTrue(reporter.failedTweets.isEmpty)
		reporter.report(
			Tweet(id: "A", date: Date(), isRetweet: true),
			success: true
		)
		XCTAssertEqual(reporter.succeededTweets.count, 1)
		XCTAssertTrue(reporter.failedTweets.isEmpty)
	}

	func testReportFailureAddsTweetToCollection() {
		let reporter = TweetDeletionReporter(totalTweets: 5)
		XCTAssertTrue(reporter.succeededTweets.isEmpty)
		XCTAssertTrue(reporter.failedTweets.isEmpty)
		reporter.report(
			Tweet(id: "A", date: Date(), isRetweet: true),
			success: false
		)
		XCTAssertTrue(reporter.succeededTweets.isEmpty)
		XCTAssertEqual(reporter.failedTweets.count, 1)
	}

	func testReportPercentageString() {
		let reporter = TweetDeletionReporter(totalTweets: 3)
		XCTAssertEqual(reporter.percentageString, "0%")
		
		reporter.report(
			Tweet(id: "A", date: Date(), isRetweet: true),
			success: true
		)
		XCTAssertEqual(reporter.percentageString, "33.33%")

		reporter.report(
			Tweet(id: "B", date: Date(), isRetweet: true),
			success: true
		)
		XCTAssertEqual(reporter.percentageString, "66.66%")

		reporter.report(
			Tweet(id: "C", date: Date(), isRetweet: true),
			success: true
		)
		XCTAssertEqual(reporter.percentageString, "100%")
	}
}
