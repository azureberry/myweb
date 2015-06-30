onReady = require '../src/coffee/app.coffee'

describe 'テスト（更新履歴）', ->

  beforeEach ->
    document.body.innerHTML = window.__html__['WebContent/history.html']
    # document.body.innerHTML = window.__html__['src/jade/history.jade']


  it 'サブメニューの最後の要素は「2006年」', ->
    submenu_link = $('.submenulist li :last')
    expect(submenu_link.text()).toEqual '2006年'

  it 'サブメニューの最後の要素のリンク先は、#submenu[0-9]*であること', ->
    submenu_link = $('.submenulist li :last')
    submenu_link_href = submenu_link.attr('href')
    expect(submenu_link_href).toMatch '^#submenu[0-9]*$'

  it 'サブメニューリンクをクリックすることで、ページ内リンク先に移動すること', ->
    # $(document).ready()
    # window.addEventListener 'load', ->
    # onReady()
    # console.log 'test1'
    submenu_link = $('.submenulist li :last')
    submenu_link_href = submenu_link.attr('href')
    link_title = $(submenu_link_href)
    expect($('html, body').scrollTop()).toEqual 0
    submenu_link.trigger("click")
    link_title = $(submenu_link_href)
    expect($('html, body').scrollTop()).toEqual link_title.position().top
    # done()
    # console.log 'test2'

  # it 'スクロールすると、サブメニューが合わせて移動すること', ->
  #   testlink = $('.submenulist li :last').text()
  #   expect(testlink).toEqual '2006年'

  # it 'スクロールすると、scrollspyが動作すること', ->
  #   testlink = $('.submenulist li :last').text()
  #   expect(testlink).toEqual '2006年'

  # it 'トップへボタンで、ページ先頭に移動すること', ->
  #   submenu_link = $('.submenulist li :last a')
  #   submenyu_link.click()
  #   submenu_link.attr('href')
  #   expect($('.submenulist li :last')).toEqual '2006年'
  #   gototop_link = $('.goto_page-top')
  #   gototop_link.click()
  #   expect(testlink).toEqual '2006年'