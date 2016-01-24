h = require('../helpers/helper')

describe 'テスト（index）', ->
  carousel_indicators = $$('.carousel-indicators li')
  carousel_items = $$('.carousel-inner .item')
  carousel_control_right = $('.carousel-control.right')

  SLEEP_TIME = 1000
  INIT_WINDOW_WIDTH = 1500
  INIT_WINDOW_HEIGHT = 1000

  beforeEach ->
    browser.driver.manage().window()
        .setSize(INIT_WINDOW_WIDTH, INIT_WINDOW_HEIGHT)
    browser.ignoreSynchronization = true
    browser.get browser.baseUrl+'/index.html'
    return


  it '[carousel]carousel-indicatorsの最後の要素をクリックすると、最後の要素が表示されること', ->
    # 初期状態で、caroucelの最後の要素がactiveでないこと
    expect(h.hasClass(carousel_indicators.last(), 'active')).toBe(false)
    expect(h.hasClass(carousel_items.last(), 'active')).toBe(false)

    # クリック
    h.clickObj(carousel_indicators.last(), SLEEP_TIME)

    # caroucelの最後の要素がactiveであること
    expect(h.hasClass(carousel_indicators.last(), 'active')).toBe(true)
    expect(h.hasClass(carousel_items.last(), 'active')).toBe(true)

  it '[carousel].carousel-controlをクリックすると、次の要素が表示されること', ->
    # 初期状態を、caroucelの最後の要素とする
    h.clickObj(carousel_indicators.last(), SLEEP_TIME)
    # 初期状態で、次の要素がactiveでないこと
    expect(h.hasClass(carousel_items.first(), 'active')).toBe(false)

    # クリック
    h.clickObj(carousel_control_right, SLEEP_TIME)

    # caroucelの次の要素がactiveであること
    expect(h.hasClass(carousel_items.first(), 'active')).toBe(true)
