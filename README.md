Rehatch
=======

One of the main problems when it comes to deleting all your tweets from your Twitter account is... Twitter. Turns out the Twitter API doesn't allow to retrieve tweets older than your last 3200 tweets.

So how does Rehatch accomplish the job then? As it turns out, Twitter does provides a way to get a compilation of all your tweets: your Twitter Archive. Rehatch takes advantage of this, and uses your archive to parse all the tweets in your account and delete them all.

## Usage

1. [__Create a Twitter application__](https://apps.twitter.com) in order to get a consumer key, consumer secret, access token and access token secret.
2. [__Download your Twitter Archive__](https://twitter.com/settings/account).
3. Run:

```bash
$ rehatch
```

## License

Rehatch is available under the MIT license.
