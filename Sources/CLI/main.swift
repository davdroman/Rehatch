import Foundation
//import Core
//
//enum Constants {
//	static let dateFormat = "dd/MM/yyyy HH:mm"
//}
//
//// Ask for Twitter API keys and tokens (generate yours here https://apps.twitter.com)
//
//let consumerKey = StringOption(
//	longFlag: "consumerKey",
//	helpMessage: "Consumer Key (API Key)."
//)
//
//let consumerSecret = StringOption(
//	longFlag: "consumerSecret",
//	helpMessage: "Consumer Secret (API Secret)."
//)
//
//let accessToken = StringOption(
//	longFlag: "accessToken",
//	helpMessage: "Access Token."
//)
//
//let accessTokenSecret = StringOption(
//	longFlag: "accessTokenSecret",
//	helpMessage: "Access Token Secret."
//)
//
//// Archive info
//
//let folderPath = StringOption(
//	shortFlag: "a",
//	longFlag: "archive",
//	helpMessage: "Path to the Twitter Archive folder."
//)
//
//// Deleting options (add "slow" flag in the future?)
//
//let limitDate = StringOption(
//	shortFlag: "d",
//	longFlag: "date",
//	helpMessage: "Limit date for tweet removal (\(Constants.dateFormat), empty for no limit)."
//)
//
//// Help
//
//let help = BoolOption(
//	shortFlag: "h",
//	longFlag: "help",
//	helpMessage: "Prints a help message."
//)
//
//let cli = CommandLineKit.CommandLine()
//cli.addOptions([
//	consumerKey,
//	consumerSecret,
//	accessToken,
//	accessTokenSecret,
//	folderPath,
//	limitDate,
//	help
//])
//
//({
//	do {
//		try cli.parse()
//	} catch {
//		cli.printUsage(error)
//		return
//	}
//
//	if help.value {
//		cli.printUsage()
//		return
//	}
//
//	let prompt = Prompter()
//
//	let consumerKeyValue = consumerKey.value ?? prompt.askString(consumerKey.helpMessage.prompted())
//	let consumerSecretValue = consumerSecret.value ?? prompt.askString(consumerSecret.helpMessage.prompted())
//	let accessTokenValue = accessToken.value ?? prompt.askString(accessToken.helpMessage.prompted())
//	let accessTokenSecretValue = accessTokenSecret.value ?? prompt.askString(accessTokenSecret.helpMessage.prompted())
//
//	if [consumerKeyValue, consumerSecretValue, accessTokenValue, accessTokenSecretValue].contains(where: { $0.isEmpty }) {
//		print("Empty keys not allowed")
//		return
//	}
//
//	let folderPathValue = folderPath.value ?? prompt.askString(folderPath.helpMessage.prompted())
//
//	if folderPathValue.isEmpty {
//		print("Empty path not allowed")
//		return
//	}
//
//	let limitDateValue: Date
//	let limitDateRawValue = limitDate.value ?? prompt.askString(limitDate.helpMessage.prompted())
//	let dateFormatter = DateFormatter()
//	dateFormatter.dateFormat = Constants.dateFormat
//
//	if limitDateRawValue.isEmpty {
//		limitDateValue = Date()
//	} else if let date = dateFormatter.date(from: limitDateRawValue) {
//		limitDateValue = date
//	} else {
//		print("Could not read specified date")
//		return
//	}
//
//	print("Reading tweets from archive")
//	switch TweetParser.parse(fromArchivePath: folderPathValue) {
//	case .success(var rawTweets):
//		print("Preparing for deletion")
//		let tweets = rawTweets.sortedTweets(until: limitDateValue)
//		let reporter = TweetDeletionReporter(totalTweets: tweets.count)
//
//		print("Connecting to the Twitter API")
//		let api = TwitterAPI(
//			consumerKey: consumerKeyValue,
//			consumerSecret: consumerSecretValue,
//			accessToken: accessTokenValue,
//			accessTokenSecret: accessTokenSecretValue
//		)
//
//		// Use semaphore so the tool doesn't get killed whilst doing background operations
//		let semaphore = DispatchSemaphore(value: 0)
//
//		echoNewline()
//		print("Deleting...")
//		tweets.forEach { tweet in
//			api.deleteTweet(tweet) { result in
//				switch result {
//				case .success:
//					reporter.report(tweet, success: true)
//				case .failure:
//					reporter.report(tweet, success: false)
//				}
//
//				semaphore.signal()
//			}
//
//			_ = semaphore.wait(timeout: .distantFuture)
//		}
//	case .failure(let error):
//		cli.printUsage(error)
//	}
//})()
