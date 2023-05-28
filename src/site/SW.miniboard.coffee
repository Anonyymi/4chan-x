SW.miniboard =
  isOPContainerThread: false
  mayLackJSON: true

  disabledFeatures: [
    'Fourchan thingies'
    'Tinyboard Glue'
    'Banner'
    'Favicon'
    'Resurrect Quotes'
    'Quick Reply Personas'
    'Quick Reply'
    'Quote Inlining'
    'Quote Previewing'
    'Quote Backlinks'
    'Quote Threading'
    'Image Expansion'
    'Image Expansion (Menu)'
    'Thread Hiding Buttons'
    'Thread Hiding (Menu)'
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
    catalog:    ({siteID, boardID})           -> "#{location.protocol}//#{siteID}/#{boardID}/catalog/"
    file: ({siteID}, filename)                -> "http://#{siteID}/src/#{filename}"
    thumb: ({siteID}, filename)               -> "http://#{siteID}/src/thumb_#{filename}"

  selectors:
    board:         '.deleteform'
    thread:        '.thread'
    threadDivider: '.deleteform > hr'
    summary:       '.omitted'
    postContainer: '.post-container'
    replyOriginal: '.reply-container'
    sideArrows:    'div.post-dash'
    post:          '.post'
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
      text:  '.file-info'
      link:  '.file-info > a'
      thumb: 'a.file-thumb-href > img'
    thumbLink: 'a.file-thumb-href'
    highlightable:
      op:      ' > .op'
      reply:   ' > .reply'
      catalog: ' > .thread'
    comment:   '.post-message'
    spoiler:   '.spoiler'
    quotelink: '.reference'
    catalog:
      board:  '#catalog'
      thread: '.thread'
      thumb:  'img[id^="thumb-"]'
    boardList: '.boardlist'
    #boardListBottom: ''
    styleSheet: 'link:not([href^="/css/index.css"])'
    #psa:       '#globalMessage'
    #psaTop:    '#globalToggle'
    #searchBox: '#search-box'
    nav:
      prev: '.pagetable a.prev'
      next: '.pagetable a.next'

  classes:
    highlight: 'highlight'

  xpath:
    thread:         'div[contains(@class, "thread")]'
    postContainer:  'div[contains(@class, "post-container")]'
    replyContainer: 'div[contains(@class, "reply-container")]'

  regexp:
    quotelink: /\/([^\/]+)\/(\d+)\/([^\/\s]+)/
    quotelinkHTML: /href="\/([^\/]+)\/(\d+)\/([^\/\s]+)"/g

  bgColoredEl: ->
    $.el 'div', className: 'reply'

  isFileURL: (url) ->
    /\/src\/[^\/]+/.test(url.pathname)

  parseNodes: (post, nodes) ->
    c.log "parseNodes post: #{post}, nodes: #{nodes}"

  parseDate: (node) ->
    c.log "parseDate node: #{node}"
    new Date()

  parseFile: (post, file) ->
    {text, link, thumb} = file
    return false if not (info = link.nextSibling?.textContent.match /([\d.]+?[KMG]?B),\s([\d.]+x[\d.]+),\s([^\\\)\/]+)/)
    
    c.log JSON.stringify info
    $.extend file,
      name: info[3]
      size: info[1]
      dimensions: info[2]
    if thumb
      $.extend file,
        thumbURL: thumb.src
    c.log JSON.stringify file
    true

  isLinkified: (link) ->
    /\bnofollow\b/.test(link.rel)
