# OctoFeed

## Intallation

### GitHub apps
You will have to [register 2 GitHub apps](https://github.com/settings/applications) with the following callbacks:
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
* A pull request is an issue. Its url is the same as an issue, but redirected from https://github.com/user/repo/issues/1 to https://github.com/user/repo/pull/1. When you click on a pull request comment (https://github.com/user/repo/issues/1#issuecomment-1234567) it is redirected to https://github.com/user/repo/pull/1 without the hash. In our version a pull request comment directly link to the correct pull url (https://github.com/user/repo/pull/1#issuecomment-1234567).
* A few typos like “1 commits” and “0 deletitions” fixes.

## Things we added
* Repo icons/avatars. A repo group will display its icon instead of the default image if the repo as an `icon.png` image in `master/root`

## Things we noted
* There seems to be some irregularities with your watching repos list (http://developer.github.com/v3/repos/watching/#list-repos-being-watched). Your own repos and some other private repos that you’re collaborating aren’t listed.
