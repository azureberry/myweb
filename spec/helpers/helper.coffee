module.exports = {
  clickObj : (myobj, sleepTime) ->
    myobj.click()
    browser.sleep(sleepTime)

  getScrollTop : ->
    browser.executeScript('return document.body.scrollTop;')

  hasClass : (element, cls) ->
    element.getAttribute('class').then (classes) ->
      classes.split(' ').indexOf(cls) != -1

  getLinkId : (url) ->
    url.substring(url.lastIndexOf('#'), url.length)
}