class OctoFeed

  constructor: ->
    this.initMoreBtn()

  initMoreBtn: ->
    $btn = $('.more')
    urlPattern = $btn.data('url-pattern')

    $btn.on 'click', (e) ->
      return false if $btn.hasClass 'loading'

      e.preventDefault()
      $btn.addClass 'loading'

      url = $btn.attr('href')
      $.get url, (data) ->
        $data = $(data)
        meta = $data[0]
        pageNumber = parseInt meta.getAttribute('content')

        $btn.attr 'href', urlPattern.replace(':number', pageNumber + 1)
        $btn.before $data.not('meta')
        $btn.removeClass 'loading'

        $btn.remove() if !pageNumber

new OctoFeed
