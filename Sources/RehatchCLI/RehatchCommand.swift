import Foundation
import ArgumentParser
import Twitter
import ShellOut

struct RehatchCommand: ParsableCommand {
    @Argument(help: "Path to your Twitter Archive .zip file", completion: .file(extensions: ["zip"]))
    var twitterArchivePath: String

    @Option(name: .customShort("d"), help: "UNIX timestamp (in seconds) until which tweets are deleted", completion: .default)
    var untilDate: Int?

    func run() throws {
        let twitterArchiveFolderName = URL(fileURLWithPath: twitterArchivePath).deletingPathExtension().lastPathComponent
        let twitterArchiveFolderPathURL = FileManager.default.temporaryDirectory.appendingPathComponent(twitterArchiveFolderName)
        let twitterArchiveFolderPath = twitterArchiveFolderPathURL.path
        _ = try shellOut(to: "unzip -qq -o \(twitterArchivePath) -d \(twitterArchiveFolderPath)")

        let archive = try Archive(contentsOfFolder: twitterArchiveFolderPath)
        let tweetsToDelete: [Archive.Tweet]
        if let untilDateUnix = untilDate {
            tweetsToDelete = archive.tweets.sortedTweets(until: Date(timeIntervalSince1970: TimeInterval(untilDateUnix)))
        } else {
            tweetsToDelete = archive.tweets
        }

        let oauthApi = OAuth.API(consumerKey: Secrets.consumerKeys)
        let requestToken = try oauthApi.requestToken()
        let authorizationResponse = try oauthApi.authorize(with: requestToken)
        let accessToken = try oauthApi.exchangeRequestTokenForAccessToken(with: requestToken, authorizationResponse: authorizationResponse)

        Logger.info(
            """
            Hey @\(accessToken.username)!
            You are about to delete \(tweetsToDelete.count) tweets.
            """
        )
        print("Would you like to proceed (y/n)?", terminator: "")
        guard let answer = readLine(), ["y", "n", "Y", "N"].contains(answer) else {
            return
        }

        let report = Archive.Tweet.DeletionReport(totalTweets: archive.tweets.count)
        Logger.step(report.progressString, succeedPrevious: false)

        let statusesAPI = StatusesAPI(consumerKey: Secrets.consumerKeys, accessToken: accessToken)
        for tweet in tweetsToDelete {
            do {
                if tweet.isRetweet {
                    try statusesAPI.unretweetTweet(with: tweet.id)
                } else {
                    try statusesAPI.deleteTweet(with: tweet.id)
                }
                report.add(tweet, success: true)
            } catch {
                report.add(tweet, success: false)
            }

            if !report.didFinish {
                Logger.step(report.progressString, succeedPrevious: false)
            } else {
                Logger.succeed(report.endString)
            }
        }
    }
}

