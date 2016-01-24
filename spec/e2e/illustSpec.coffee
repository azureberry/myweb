h = require('../helpers/helper')

describe 'テスト（illust）', ->
  lightbox_parent_item = $('html')
  gallery_item_first = $$('.gallery li').first()

  SLEEP_TIME = 1000
  INIT_WINDOW_WIDTH = 1500
  INIT_WINDOW_HEIGHT = 1000


  beforeEach ->
    browser.driver.manage().window()
        .setSize(INIT_WINDOW_WIDTH, INIT_WINDOW_HEIGHT)
    browser.ignoreSynchronization = true
    browser.get browser.baseUrl+'/illust.html'
    return


  it '[lightbox]イラストをクリックすると、lightboxが実行されること', ->
    # 初期状態で、lightboxが実行されていないこと
    expect(h.hasClass(lightbox_parent_item, 'fancybox-lock')).toBe(false)

    # クリック
    h.clickObj(gallery_item_first, SLEEP_TIME)

    # lightboxが実行されること
    expect(h.hasClass(lightbox_parent_item, 'fancybox-lock')).toBe(true)

