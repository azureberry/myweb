onReady = ->
# $(document).ready ->

  #go to TOP
  pageTop = $('.gototop')
  pageTop.hide()
  $(window).scroll ->
      if $(this).scrollTop() > $(window).height()/2
        pageTop.fadeIn()
      else
        pageTop.fadeOut()
  pageTop.bind 'click', ->
    $('body, html').animate {scrollTop : 0}, 200, 'swing'
    false

  #ページ内リンク
  headerH = parseInt($('.main-row').css('padding-top'), 10)
  $('a[href^=#]:not([href^=#myCarousel])').bind 'click', ->
    href = $(this).attr('href')
    target = $(if href == '#' or href == '' then 'html' else href)
    position = target.offset().top - headerH
    $('html, body').animate {scrollTop : position}, 200, 'swing'
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

  #carousel
  # $('.carousel').carousel({
  #       interval: 5000
  #   })

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
