# OctoFeed

## Installation
```sh
$ cp config/environment.rb.sample config/environment.rb
# Then set your GitHub app id & secret in `config/environment.rb`
$ git submodule init && git submodule update
```

### Collaborators
If you happen to be a collaborator and you’re using the original app (lucky bastard), you’ll need to add these lines to your `/etc/hosts` file:

```rb
127.0.0.1 octofeed.dev
```

and launch the app with `shotgun` then use http://octofeed.dev:9393 as your dev environment.


## What this app is not
* This is not meant to be a third party tool. This is only a proof concept, a UX redesign of your lovely GitHub news feed. I do believe it would be usable, but not quite fast just yet.
* This is not a “we made a more performant news feed” kind of app. We’re only trying to fix/suggest what’s lacking and performance is not the issue here.


## The thinking
When you get an event in your news feed, you’re either:
* Following the actor (user);
* Watching the repo.

Oh! Surely we should make that info more in evidence and group events accordingly. So here we are with 2 ways of grouping our events. But that’s not enough. Based on an event data, we can easily create more specific group types:
* Pushes to a repo
* Actions on an issue (open, close, comment)
* Actions on a pull request (open, close, merge, comment)
* Generic user actions (follow, watch)
* Gist activity

Each group will have a different heading depending on its type (list above) and if you follow the user or watch the repo.


## Quirks we “fixed”
* A pull request is an issue. Its url is the same as an issue, but redirected from https://github.com/user/repo/issues/1 to https://github.com/user/repo/pull/1. When you click on a pull request comment (https://github.com/user/repo/issues/1#issuecomment-1234567) it is redirected to https://github.com/user/repo/issues/1 without the hash. In our version a pull request comment directly link to the correct pull url (https://github.com/user/repo/pull/1#issuecomment-1234567).


## Things we won’t do
* We’re somewhat limited by the API and we’ll not make any more requests than what we have — one for your events and another one for the repos you watch — the app is slow enough. For example: On GitHub when there’s a `PushEvent`, you see the actor’s avatar and all the commits’ author. The `PushEvent` json only provides the author’s full name and email. To be able to print their avatars we’d have to call the API for each commit… no thanks.
