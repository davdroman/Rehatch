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
let limitDate = StringOption(shortFlag: "d", longFlag: "date", helpMessage: "Limit date for tweet removal (dd/MM/yyyy hh:mm).")
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

	let folderPathValue = folderPath.value ?? prompt.askString(folderPath.helpMessage)
//	let limitDateRawValue = folderPath.value ?? prompt.askString(limitDate.helpMessage)

	let dateFormatter = DateFormatter()
//	dateFormatter.dateFormat = "h:mm a - M MMM yyyy"
//	print(dateFormatter.date(from: "5:15 am - 31 May 2016"))
//	dateFormatter.dateFormat = "dd/M/yy h:mm"
//	print(dateFormatter.date(from: "31/5/16 5:15"))

	do {
		let tweets = try TweetParser(path: folderPathValue).parse()
		for tweet in tweets {
			TwitterAPI.instance.deleteTweet(tweet)
			sleep(1)
		}
	} catch {
		cli.printUsage(error)
		return
	}

//	if let limitDateValue = DateFormatter()

//	print(dateFormatter.string(from: Date()))
})()
