$(document).foundation()

$(document).ready ->
  # lightbox prettyPhoto
  $('.fancybox').fancybox(
    helpers :
      title :
        type : 'insite'
      thumbs :
        width : 50,
        height : 50
  )
