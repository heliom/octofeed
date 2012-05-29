# github-newsfeed

## Installation
```sh
$ cp config/environment.rb.sample config/environment.rb
# Then set your GitHub app id & secret in `config/environment.rb`
```

### Collaborators
If you happen to be a collaborator and you’re using the original app (lucky bastard), you’ll need to add these lines to your `/etc/hosts` file:

```rb
127.0.0.1 githubnewsfeed.dev
```

and launch the app with `shotgun` then use http://githubnewsfeed.dev:9393 as your dev environment.


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

Each group will have a different heading depending on its type (list above) and if you follow the user or watch the repo.
