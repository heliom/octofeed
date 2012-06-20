$.fn.onClickOrTouch = (callback) ->
  if window.ontouchend != undefined
    this.each -> this._touchMoveCount = 0
    this.on 'click', -> return false

    this.on 'touchmove', ->
      this._touchMoveCount++

    this.on 'touchend', (e) ->
      if this._touchMoveCount < 3
        callback.call this, e

      this._touchMoveCount = 0
  else
    this.on 'click', callback

class OctoFeed

  constructor: ->
    @cache = {}
    this.initMoreBtn()
    this.setReposIcon $('.repo-group')

  initMoreBtn: ->
    $btn = $('.more')
    urlPattern = $btn.data('url-pattern')

    $btn.onClickOrTouch (e) =>
      return false if $btn.hasClass 'loading'

      e.preventDefault()
      $btn.addClass 'loading'

      url = $btn.attr('href')
      $.get url, (data) =>
        $data = $(data)
        meta = $data[0]
        pageNumber = parseInt meta.getAttribute('content')

        $btn.attr 'href', urlPattern.replace(':number', pageNumber + 1)
        $btn.before $data.not('meta')
        $btn.removeClass 'loading'
        this.setReposIcon $data.filter('.repo-group')

        $btn.remove() if !pageNumber

  setReposIcon: ($repos) ->
    $repos.each (i, elem) =>
      $elem = $(elem)
      repoName = $elem.data 'name'
      icon = $elem.find '.avatar > img'

      if @cache[repoName]
        icon.attr('src', @cache[repoName]) if @cache[repoName] != 'error'
      else
        url = "https://github.com/#{repoName}/raw/master/icon.png"
        image = new Image()
        image.src = url

        $(image).on 'load', (e) =>
          icon.attr 'src', url
          @cache[repoName] = url

        $(image).on 'error', (e) =>
          @cache[repoName] = 'error'

new OctoFeed
