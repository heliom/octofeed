# OctoFeed

## Installation

### GitHub apps
You need to [register 2 GitHub apps](https://github.com/settings/applications) with the following callbacks:
```
http://yourdomain.com/auth/github_public/callback
http://yourdomain.com/auth/github_private/callback
```

Personally, I added `127.0.0.1 octofeed.dev` in my `/etc/hosts` file and serve the app with [Shotgun](https://github.com/rtomayko/shotgun/). The domain of the apps is `http://octofeed.dev:9393`.

### Environment configuration
Set your GitHub apps id & secret in `config/environment.rb`. You may also want to change your database URI.
```sh
$ cp config/environment.rb.sample config/environment.rb
```

### MongoDB
The easiest way to install MongoDB is with [Homebrew](http://mxcl.github.com/homebrew/):

```sh
$ brew install mongodb
```

Don’t forget to follow the instructions at the end of the install script.

### Ruby dependencies
```sh
$ gem install bundler
$ bundle install
```

### Node.js modules (dev dependencies)
The app is developed with [Stylus](https://github.com/Learnboost/stylus) (with [nib](https://github.com/visionmedia/nib)) & [CoffeeScript](https://github.com/jashkenas/coffee-script). Both are required if you want to run the app locally.
```sh
$ npm install
```

### Submodules
* [heliom/stylus-utils](https://github.com/heliom/stylus-utils)

```sh
$ git submodule init && git submodule update
```

## The Thinking
http://heliom.ca/en/blog/octofeed

## Things we fixed
* A pull request is an issue. It responds to the issue URL [/user/repo/issues/1]() but redirects to the pull URL [/user/repo/pull/1](). In the current GitHub news feed, pull request comments links [/user/repo/issues/1#issuecomment-1234567]() lose their anchor after the redirection [/user/repo/pull/1](). In OctoFeed, a pull request comment correctly links to the pull URL [/user/repo/pull/1#issuecomment-1234567]().
* A few typos like “1 commits” and “0 deletitions”.

## Things we added
* Repo icon/avatar. If a repo has an `/icon.png` image in its `master` branch, it will be displayed in repo-related feed entries.
* Unfollowed users and unwatched repos events are not listed.

## Things we noted
* There seems to be some irregularities with your watched repos list (http://developer.github.com/v3/repos/watching/#list-repos-being-watched). Your own repos and some other private repos you’re collaborating on aren’t listed.
