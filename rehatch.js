#!/usr/bin/env node

// Requires

var chalk = require('chalk')
var twit = require('twit')
var prompt = require('prompt')
var fs = require('fs')
var nconf = require('nconf')

// Configuration

nconf.use('file', {file: 'config.json'})
nconf.load()

var consumerKey = nconf.get('consumer_key')
var consumerSecret = nconf.get('consumer_secret')
var accessToken = nconf.get('access_token')
var accessTokenSecret = nconf.get('access_token_secret')
var problematicTweetIds = nconf.get('problematic_tweet_ids')

// Prompting

var schema = {
    properties: {
        consumerKey: {
            description: 'Enter your consumer key',
            type: 'string',
            default: consumerKey,
            required: !consumerKey
        },
        consumerSecret: {
            description: 'Enter your secret consumer key',
            type: 'string',
            default: consumerSecret,
            required: !consumerSecret
        },
        accessToken: {
            description: 'Enter your access token',
            type: 'string',
            default: accessToken,
            required: !accessToken
        },
        accessTokenSecret: {
            description: 'Enter your secret access token',
            type: 'string',
            default: accessTokenSecret,
            required: !accessTokenSecret
        }
    }
}

if (problematicTweetIds && problematicTweetIds.length > 0) {
    schema.properties.shouldDeleteProblematicTweetsOnly = {
        description: 'Delete only problematic tweets? (' + problematicTweetIds.length + ' remaining) [y/n]',
        type: 'string',
        required: true
    }
}

prompt.message = ''
prompt.delimiter = ''
console.log('')
prompt.start()
prompt.get(schema, function (error, result) {
    nconf.set('consumer_key', result.consumerKey)
    nconf.set('consumer_secret', result.consumerSecret)
    nconf.set('access_token', result.accessToken)
    nconf.set('access_token_secret', result.accessTokenSecret)
    nconf.save()

    var twitter = new twit({
        consumer_key: result.consumerKey,
        consumer_secret: result.consumerSecret,
        access_token: result.accessToken,
        access_token_secret: result.accessTokenSecret
    })

    var arguments = process.argv.splice(1)
    var tweetFilesPath = arguments[1] + '/data/js/tweets'
    console.log('\nRetrieving tweets from Twitter archive\n')
    var tweetFiles = fs.readdirSync(tweetFilesPath)
    var tweetIds = []

    tweetFiles.forEach(function(tweetFile) {
        var rawTweetFileData = fs.readFileSync(tweetFilesPath + '/' + tweetFile).toString()

        var position = rawTweetFileData.indexOf('\n')
        if (position != -1) {
            var tweetFileData = rawTweetFileData.substr(position + 1)

            var tweets = JSON.parse(tweetFileData)
            tweets.forEach(function(tweet) {
                if (result.shouldDeleteProblematicTweetsOnly == 'y') {
                    if (problematicTweetIds.indexOf(tweet.id_str) != -1) {
                        tweetIds.push(tweet.id_str)
                    }
                } else {
                    tweetIds.push(tweet.id_str)
                }
            })
        }
    })

    problematicTweetIds = []

    var previousId = ''
    function deleteTweets(tweetIds, callback) {
        var index = tweetIds.indexOf(previousId)
        var id = tweetIds[index+1]

        if (index < tweetIds.length-1) {
            twitter.post('statuses/destroy/:id', {id: id}, function(error) {
                if (error) {
                    if (error.code == 144) {
                        console.log('Tweet ' + id + ' was already deleted')
                    } else if (error.code == 89) {
                        console.log(chalk.red('Invalid API keys/tokens\n'))
                        return
                    } else {
                        problematicTweetIds.push(id)
                        console.log(chalk.red('Tweet ' + id + ' could not be deleted due to an error'))
                    }
                } else {
                    console.log(chalk.green('Tweet ' + id + ' deleted'))
                }

                previousId = id
                deleteTweets(tweetIds, callback)
            })
        } else {
            callback()
        }
    }

    deleteTweets(tweetIds, function() {
        console.log(chalk.cyan('\nRehatch completed'))

        if (problematicTweetIds.length > 0) {
            console.log(chalk.yellow('However, errors have ocurred while deleting ' + problematicTweetIds.length + ' tweets'))
            console.log(chalk.yellow('Try running rehatch again to delete those problematic tweets'))
        }

        console.log('')

        nconf.set('problematic_tweet_ids', problematicTweetIds)
        nconf.save()
    })
})
