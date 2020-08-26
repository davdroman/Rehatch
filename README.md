# Rehatch

The main problem when it comes to deleting all your tweets from your account is the Twitter API doesn't allow retrieval of tweets further than your last ~3000. Rehatch overcomes this problem by using your Twitter Archive instead.

## Installation

```sh
brew tap davdroman/tap
brew install rehatch
```

## Usage

1. [__Download your Twitter Archive__](https://twitter.com/settings/your_twitter_data).
2. Run:

```sh
rehatch <twitterArchiveZip>
```

You can optionally specify a `--until-date` UNIX timestamp to delete tweets only until a certain date.
