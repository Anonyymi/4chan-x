SW.miniboard =
  isOPContainerThread: true
  mayLackJSON: true

  # TODO:
  # - encapsulate op post to container

  disabledFeatures: [
    'Banner'
  ]

  detect: ->
    for anchor in $$ 'div.footer > a', d.body
      if anchor.textContent == 'miniboard'
        properties = $.dict()
        return properties
    false

  urls:
    thread:     ({siteID, boardID, threadID}) -> "#{location.protocol}//#{siteID}/#{boardID}/#{threadID}"
    post:       ({boardID, postID})           -> "##{boardID}-#{postID}"
    index:      ({siteID, boardID})           -> "#{location.protocol}//#{siteID}/#{boardID}/"
    catalog:    ({siteID, boardID})           -> "#{location.protocol}//#{siteID}/#{boardID}/catalog"
    file: ({siteID}, filename)                -> "http://#{siteID}/src/#{filename}"
    thumb: ({siteID}, filename)               -> "http://#{siteID}/src/thumb_#{filename}"

  selectors:
    board:         '.deleteform'
    thread:        '.post:not(.reply)'
    threadDivider: '.deleteform > hr'
    summary:       '.omitted'
    postContainer: '.post:not(.reply)'
    replyOriginal: '.reply:not(.post)'
    sideArrows:    'div.post-dash'
    infoRoot:      '.post-info'
    info:
      subject:   '.post-subject'
      name:      '.post-name'
      email:     'a[href^="mailto:"]'
      tripcode:  '.post-trip'
      #uniqueID:  ''
      capcode:   '.post-cap'
      date:      '.post-datetime'
      nameBlock: 'label'
      quote:     'a[href*="#q"]'
      reply:     'a[href*="#*-"]'
    icons:
      isSticky:   'img[src="/static/sticky.png"]'
      isClosed:   'img[src="/static/lock.png"]'
    file:
      text:  'div.file-info'
      link:  'div.file-info > a'
      thumb: 'a.file-thumb-href > img'
    thumbLink: 'a.file-thumb-href'
    highlightable:
      op:      '.post:not(.reply)'
      reply:   '.reply'
      catalog: '.post-catalog'
    comment:   '.post-message'
    spoiler:   '.spoiler'
    quotelink: '.reference'
    catalog:
      board:  'body'
      thread: '.post-catalog'
      thumb:  'img[id^="thumb-"]'
    boardList: '.boardlist'
    #boardListBottom: ''
    styleSheet: 'link:not([href^="/css/index.css"])'
    #psa:       '#globalMessage'
    #psaTop:    '#globalToggle'
    #searchBox: '#search-box'
    # nav:
    #   prev: '.prev > form > [type=submit]'
    #   next: '.next > form > [type=submit]'

  classes:
    highlight: 'highlight'

  xpath:
    thread:         'div[contains(@class, "post") and not contains(@class, "reply")]'
    postContainer:  'div[contains(@class, "post") and not contains(@class, "reply")]'
    replyContainer: 'div[contains(@class, "post") and contains(@class, "reply")]'

  regexp:
    quotelink:
      ///
        /
        ([^/]+) # boardID
        /
        (\d+)   # threadID
        /
        ([^/]+) # boardID
        (?:\.\w+)?\#
        -
        (\d+)   # postID
        $
      ///
    quotelinkHTML:
      /<a [^>]*\bhref="[^"]*\/([^\/]+)\/(\d+)(?:\.\w+)?#([^\/]+)-(\d+)"/g

  bgColoredEl: ->
    $.el 'div', className: 'post reply'

  isFileURL: (url) ->
    /\/src\/[^\/]+/.test(url.pathname)

  parseNodes: (post, nodes) ->
    c.log "parseNodes post: #{post}, nodes: #{nodes}"

  parseDate: (node) ->
    c.log "parseDate node: #{node}"
    new Date()

  parseFile: (post, file) ->
    {text, link, thumb} = file
    c.log "parseFile: #{text}"
    return false if not (info = link.nextSibling?.textContent.match /\((.*,\s*)?([\d.]+ ?[KMG]?B).*\)/)
    c.log JSON.stringify info
    $.extend file,
      name: text.title or link.title or link.textContent
      size: info[2]
      dimensions: info[0].match(/\d+x\d+/)?[0]
    if thumb
      $.extend file,
        thumbURL: thumb.src
    c.log JSON.stringify file
    true

  isLinkified: (link) ->
    /\bnofollow\b/.test(link.rel)
