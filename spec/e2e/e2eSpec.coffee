describe 'テスト（更新履歴）', ->
  # firstNumber = element(By.model('first'))
  # secondNumber = element(By.model('second'))
  # goButton = element(By.id('gobutton'))
  # latestResult = element(By.binding('latest'))
  # history = element.all(By.repeater('result in memory'))

  # add = (a, b) ->
  #   firstNumber.sendKeys a
  #   secondNumber.sendKeys b
  #   goButton.click()
  #   return

  beforeEach ->
    # browser.get 'http://juliemr.github.io/protractor-demo/'
    browser.get browser.baseUrl+'/history.html'
    browser.ignoreSynchronization = true;
    return


  # it 'should have a history', ->
  #   add 1, 2
  #   add 3, 4
  #   expect(history.count()).toEqual 2
  #   add 5, 6
  #   expect(history.count()).toEqual 3 # This is wrong!
  #   return
  # return


  it 'サブメニューの最後の要素は「2006年」', ->
    # submenu_link = $('.submenulist li :last')
    element By.id '.submenulist'
    # expect(submenu_link.text()).toEqual '2006年'

  # it 'サブメニューの最後の要素のリンク先は、#submenu[0-9]*であること', ->
  #   submenu_link = $('.submenulist li :last')
  #   submenu_link_href = submenu_link.attr('href')
  #   expect(submenu_link_href).toMatch '^#submenu[0-9]*$'

  # it 'サブメニューリンクをクリックすることで、ページ内リンク先に移動すること', ->
  #   submenu_link = $('.submenulist li :last')
  #   submenu_link_href = submenu_link.attr('href')
  #   link_title = $(submenu_link_href)
  #   expect($('html, body').scrollTop()).toEqual 0
  #   submenu_link.trigger("click")
  #   link_title = $(submenu_link_href)
  #   expect($('html, body').scrollTop()).toEqual link_title.position().top


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
