describe 'テスト（更新履歴）', ->

  submenu_link_list = $$('.submenulist li')
  submenu_link_last = submenu_link_list.last()
  # submenu_link_href = submenu_link_last.$('a').getAttribute('href')
  # submenu_link_id = substring(submenu_link_href.getText().lastIndexOf('#'), submenu_link_href.getText().length)
  submenu = $('.submenulist')
  gototop_link = $('.gototop')
  SLEEP_TIME = 1000

  hasClass = (element, cls) ->
    element.getAttribute('class').then (classes) ->
      classes.split(' ').indexOf(cls) != -1


  beforeEach ->
    width = 1500
    height = 1000
    browser.driver.manage().window().setSize(width, height)
    browser.ignoreSynchronization = true
    browser.get browser.baseUrl+'/history.html'
    return


  it 'サブメニューの最後の要素は「2006年」', ->
    expect(submenu_link_last.getText()).toEqual '2006年'

  it 'サブメニューの最後の要素のリンク先は、#submenu[0-9]*であること', ->
    # submenu_link_href = submenu_link_last.$('a').getAttribute('href')
    submenu_link_last.$('a').getAttribute('href').then (submenu_link_url) ->
      expect(submenu_link_url).toMatch '#submenu[0-9]*$'

  it 'サブメニューリンクをクリックすることで、ページ内リンク先に移動すること', ->
    # 初期スクロール位置の確認
    browser.executeScript('return document.body.scrollTop;').then (scrollTop) ->
      expect(scrollTop).toEqual 0

    # サブメニューリンクをクリック
    submenu_link_last.click()
    browser.sleep(SLEEP_TIME)

    # クリック後のスクロール位置の確認
    submenu_link_last.$('a').getAttribute('href').then (submenu_link_url) ->
      submenu_link_id = submenu_link_url.substring(
                                             submenu_link_url.lastIndexOf('#'),
                                             submenu_link_url.length)
      $(submenu_link_id).getLocation().then (locationdata) ->
        browser.executeScript('return document.body.scrollTop;').then (scrollTop) ->
          expect(scrollTop).toEqual locationdata.y - 70


  it 'スクロールすると、サブメニューが合わせて移動すること', ->
    # サブメニューの初期location取得
    init_locationdata_y = 0
    submenu.getLocation().then (locationdata) ->
      init_locationdata_y = locationdata.y

    # スクロール
    submenu_link_last.click()
    browser.sleep(SLEEP_TIME)

    # スクロール後のサブメニューの位置が、スクロール量+初期locationであること
    browser.executeScript('return document.body.scrollTop;').then (scrollTop) ->
      submenu.getLocation().then (locationdata) ->
        expect(locationdata.y).toEqual scrollTop + init_locationdata_y

  it 'スクロールすると、scrollspyが動作すること', ->
    # 初期のactiveクラス取得
    expect(hasClass(submenu_link_last, 'active')).toBe(false)

    # スクロール
    submenu_link_last.click()
    browser.sleep(SLEEP_TIME)

    # スクロール後に、titleに一致した項目がactiveになっていること
    expect(hasClass(submenu_link_last, 'active')).toBe(true)

  it 'トップへボタンで、ページ先頭に移動すること', ->
    # トップへボタンをクリック前に、スクロールする。初期位置が正しいこと
    submenu_link_last.click()
    browser.sleep(SLEEP_TIME)
    browser.executeScript('return document.body.scrollTop;').then (scrollTop) ->
      expect(scrollTop).toBeGreaterThan 0

    # トップへボタンをクリック
    gototop_link.click()
    browser.sleep(SLEEP_TIME)

    # ページ先頭に移動していること
    browser.executeScript('return document.body.scrollTop;').then (scrollTop) ->
      expect(scrollTop).toEqual 0