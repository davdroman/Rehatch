//
//  main.swift
//  Rehatch
//
//  Created by David Román Aguirre on 23/01/2017.
//
//

import Foundation
import CommandLineKit
import CSV

let folderPath = StringOption(shortFlag: "a", longFlag: "archive", helpMessage: "Path to the Twitter Archive folder.")
let limitDate = StringOption(shortFlag: "d", longFlag: "date", helpMessage: "Limit date for tweet removal (dd/MM/yyyy hh:mm, empty for no limit).")
let help = BoolOption(shortFlag: "h", longFlag: "help", helpMessage: "Prints a help message.")

let cli = CommandLineKit.CommandLine(options: folderPath, help)

({
	do {
		try cli.parse()
	} catch {
		cli.printUsage(error)
		return
	}

	let prompt = Prompter()

	let folderPathValue = folderPath.value ?? prompt.askString(folderPath.helpMessage.prompted())
	let limitDateValue: Date

	let limitDateRawValue = folderPath.value ?? prompt.askString(limitDate.helpMessage.prompted())
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"

	if limitDateRawValue.isEmpty {
		limitDateValue = Date()
	} else if let date = dateFormatter.date(from: limitDateRawValue) {
		limitDateValue = date
	} else {
		print("Could not read specified date")
		return
	}

	let semaphore = DispatchSemaphore(value: 1)

	switch TweetParser(path: folderPathValue).parse() {
	case .success(var tweets):
		let tweets = tweets.sorted { $0.date < $1.date }.filter { $0.date < limitDateValue }
		let api = TwitterAPI(consumerKey: "", consumerSecret: "")

		api.deleteTweets(tweets, completion: {
			semaphore.signal()
		})
	case .failure(let error):
		cli.printUsage(error)
	}

	_ = semaphore.wait(timeout: .distantFuture)
})()
