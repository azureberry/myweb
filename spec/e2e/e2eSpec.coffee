h = require('../helpers/helper')

describe 'テスト（更新履歴）', ->

  submenu_link_list = $$('.submenulist li')
  submenu_link_last = submenu_link_list.last()
  submenu = $('.submenulist')
  mainrow = $('.main-row')
  gototop_link = $('.gototop')

  SLEEP_TIME = 1000
  INIT_WINDOW_WIDTH = 1500
  INIT_WINDOW_HEIGHT = 1000
  SCROLL_TEST_ITEM = 5


  beforeEach ->
    browser.driver.manage().window()
        .setSize(INIT_WINDOW_WIDTH, INIT_WINDOW_HEIGHT)
    browser.ignoreSynchronization = true
    browser.get browser.baseUrl+'/history.html'
    return


  it 'サブメニューの最後の要素は「2006年」', ->
    expect(submenu_link_last.getText()).toEqual '2006年'

  it 'サブメニューの最後の要素のリンク先は、#submenu[0-9]*であること', ->
    submenu_link_last.$('a').getAttribute('href').then (submenu_link_url) ->
      expect(submenu_link_url).toMatch '#submenu[0-9]*$'

  it 'サブメニューリンクをクリックすることで、ページ内リンク先に移動すること', ->
    # 初期スクロール位置の確認
    expect(h.getScrollTop()).toEqual 0

    # サブメニューリンクをクリック
    h.clickObj(submenu_link_last, SLEEP_TIME)

    # クリック後のスクロール位置の確認
    submenu_link_last.$('a').getAttribute('href').then (submenu_link_url) ->
      submenu_link_id = h.getLinkId(submenu_link_url)
      $(submenu_link_id).getLocation().then (locationdata) ->
        mainrow.getCssValue('padding-top').then (headerH) ->
          expect(h.getScrollTop()).toEqual locationdata.y - parseInt(headerH, 10)


  it 'スクロールすると、サブメニューが合わせて移動すること', ->
    # サブメニューの初期location取得
    init_locationdata_y = 0
    submenu.getLocation().then (locationdata) ->
      init_locationdata_y = locationdata.y

    # スクロール
    h.clickObj(submenu_link_list.get(SCROLL_TEST_ITEM), SLEEP_TIME)

    # スクロール後のサブメニューの位置が、スクロール量+初期locationであること
    h.getScrollTop().then (scrollTop) ->
      submenu.getLocation().then (locationdata) ->
        expect(locationdata.y).toEqual scrollTop + init_locationdata_y

  it 'スクロールすると、scrollspyが動作すること', ->
    # 初期はactive状態ではないこと
    expect(h.hasClass(submenu_link_list.get(SCROLL_TEST_ITEM), 'active')).toBe(false)

    # スクロール
    h.clickObj(submenu_link_list.get(SCROLL_TEST_ITEM), SLEEP_TIME)

    # スクロール後に、titleに一致した項目がactiveになっていること
    expect(h.hasClass(submenu_link_list.get(SCROLL_TEST_ITEM), 'active')).toBe(true)

  it 'トップへボタンで、ページ先頭に移動すること', ->
    # トップへボタンをクリック前に、スクロールする。初期位置がページ先頭でないこと
    h.clickObj(submenu_link_list.get(SCROLL_TEST_ITEM), SLEEP_TIME)
    expect(h.getScrollTop()).toBeGreaterThan 0

    # トップへボタンをクリック
    h.clickObj(gototop_link, SLEEP_TIME)

    # ページ先頭に移動していること
    expect(h.getScrollTop()).toEqual 0