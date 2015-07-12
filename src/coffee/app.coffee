onReady = ->
# $(document).ready ->

  #go to TOP
  pageTop = $('.gototop')
  # pageTop.hide()
  # $(window).scroll ->
  #     if $(this).scrollTop() > 600
  #       pageTop.fadeIn()
  #     else
  #       pageTop.fadeOut()
  pageTop.bind 'click', ->
    $('body, html').animate {scrollTop : 0}, 200, 'swing'
    false

  #affix
  $affix = $('.side-nav')
  # $affix.affix
  #   offset:
  #     top: position.top
  #     bottom: 200  #-> this.bottom = $('.footer').outerHeight(true)
  $affix.width $affix.parent().width()

  #scrollspy
  # $('body').scrollspy
  #   target: '.submenulist'
  #   offset: '85'

  #ページ内リンク
  headerH = 70 #$('.main-row').attr('padding-top')
  $('a[href^=#]').bind 'click', ->
    href = $(this).attr('href')
    target = $(if href == '#' or href == '' then 'html' else href)
    position = target.offset().top - headerH
    $('html, body').animate {scrollTop : position}, 200, 'swing'
    false

  # lightbox prettyPhoto
  $('.fancybox').fancybox(
    helpers :
      title :
        type : 'insite'
      thumbs :
        width : 50,
        height : 50
  )


$(document).ready onReady


$(window).resize ->
  $affix = $('.side-nav')
  $affix.width $affix.parent().width()
