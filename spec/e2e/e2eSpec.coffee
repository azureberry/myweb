describe 'テスト（更新履歴）', ->

  submenu_link_last = $$('.submenulist li').last()


  beforeEach ->
    width = 1500;
    height = 1000;
    browser.driver.manage().window().setSize(width, height);
    browser.ignoreSynchronization = true;
    browser.get browser.baseUrl+'/history.html'
    return


  it 'サブメニューの最後の要素は「2006年」', ->
    expect(submenu_link_last.getText()).toEqual '2006年'

  it 'サブメニューの最後の要素のリンク先は、#submenu[0-9]*であること', ->
    submenu_link_href = submenu_link_last.$('a').getAttribute('href')
    expect(submenu_link_href).toMatch '#submenu[0-9]*$'

  it 'サブメニューリンクをクリックすることで、ページ内リンク先に移動すること', ->
    # browser.executeScript('return document.body.scrollTop;').then (scrollTop) ->
    #   expect(scrollTop).toEqual 0

    # browser.wait(submenu_link_last.click, 50)
    # # submenu_link_last.click
    # # browser.sleep(500)

    # $('#submenu8').getLocation().then (someclass_data) ->
    #   submenu_linkto_position_y = someclass_data.y
    #   browser.executeScript('return document.body.scrollTop;').then (scrollTop) ->
    #     expect(scrollTop).toEqual submenu_linkto_position_y


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
