rehatch
=======

One of the main problems when it comes to deleting all your tweets from your Twitter account is... Twitter. Turns out the Twitter API doesn't allow to retrieve tweets older than your last 3200 tweets. In other words: you can't really delete all your tweets purely from the Twitter API.

So how does rehatch work, then? Well, turns out Twitter __does__ provide a way to get a compilation of all your tweets: your Twitter Archive. Rehatch takes advantage of this, and uses your archive to parse all the tweets in your account and delete them one by one.

Rehatch doesn't work at light speed. You'll probably need to wait for a while before it completes. It all depends on the number of tweets you have.

## Usage

1. [__Create a Twitter application__](https://apps.twitter.com) in order to get a consumer key, consumer secret, access token and access token secret.
2. [__Download your Twitter Archive__](https://twitter.com/settings/account).
3. Run the following:

```bash
$ [sudo] npm install -g rehatch
```

```bash
$ [sudo] rehatch PATH_TO_TWITTER_ARCHIVE_FOLDER
```

## License

Rehatch is available under the MIT license.