window.render_led_display = ->
  for channel in [1, 2]
    for col in [11, 8, 4, 0]
      div = $('<div class="display_col">')
      div.appendTo('#display_container');
      for row in [0..4]
        img = $('<img>')
        img.attr('src', 'led-on.png')
        img.addClass('channel_' + channel)
        img.addClass('position_' + (col+row))
        img.appendTo(div)
