describe "最初のテスト", () ->

  beforeEach ->
    browser.navigateTo('/base/WebContent/history.html')
    browser.waitForPageLoad()
    console.log browser.window.path()
    console.log browser.window.href()



  it "TOPページのタイトルが、正しいこと", () ->
    submenu_link = $('.submenulist li :last')
    expect(submenu_link.text()).toEqual '2006年'
    # expect(document.title).to.equal("Jumble Junk")


  # it 'トップへボタンで、ページ先頭に移動すること', ->
  #   submenu_link = $('.submenulist li :last a')
  #   submenyu_link.click()
  #   submenu_link.attr('href')
  #   expect($('.submenulist li :last')).toEqual '2006年'
  #   gototop_link = $('.goto_page-top')
  #   gototop_link.click()
  #   expect(testlink).toEqual '2006年'