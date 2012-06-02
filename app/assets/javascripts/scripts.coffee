class OctoFeed

  constructor: ->
    this.initMoreBtn()
    this.initRepoImages()

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

  initRepoImages: ->
    $('[data-repo-image]').each (i, elem) ->
      url = elem.getAttribute('data-repo-image')
      image = new Image()

      $(image).on 'load', (e) ->
        elem.src = url

      image.src = url

new OctoFeed
