//
//  TwitterAPI.swift
//  Rehatch
//
//  Created by David Román Aguirre on 23/01/2017.
//
//

import Foundation
import Swifter

final class TwitterAPI {

	static let instance = TwitterAPI()

	func deleteTweet(_ tweet: Tweet) {
		print("Tweet \(tweet.id) deleted")
		let swifter = Swifter(consumerKey: <#T##String#>, consumerSecret: <#T##String#>)
	}
}
