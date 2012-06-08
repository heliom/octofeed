# OctoFeed

## Installation
```sh
$ cp config/environment.rb.sample config/environment.rb
# Then set your GitHub app id & secret in `config/environment.rb`
$ git submodule init && git submodule update
$ npm install
```

## What this app is not
* This is not meant to be a third party tool. This is only a proof concept, a UX redesign of your lovely GitHub news feed. I do believe it would be usable, but not quite fast just yet.
* This is not a “we made a more performant news feed” kind of app. We’re only trying to fix/suggest what’s lacking and performance is not the issue here.

## The Thinking
http://heliom.ca/en/blog/octofeed

## Things we fixed
* A pull request is an issue. Its url is the same as an issue, but redirected from https://github.com/user/repo/issues/1 to https://github.com/user/repo/pull/1. When you click on a pull request comment (https://github.com/user/repo/issues/1#issuecomment-1234567) it is redirected to https://github.com/user/repo/pull/1 without the hash. In our version a pull request comment directly link to the correct pull url (https://github.com/user/repo/pull/1#issuecomment-1234567).
* A few typos like “1 commits” and “0 deletitions” fixes.

## Things we added
* Repo icons/avatars. A repo group will display its icon instead of the default image if the repo as an `icon.png` image in `master/root`

## Things GitHub could update
* Your own repos aren’t listed in that list: http://developer.github.com/v3/repos/watching/#list-repos-being-watched. Would make sense if they were, no?
