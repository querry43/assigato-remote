window.render_led_display = ->
  for channel in [1, 0]
    for col in [12, 8, 4, 0]
      div = $('<div class="led_display_col">')
      div.addClass('channel_' + channel)
      div.appendTo('div.led_display_container');
      for row in [0..3]
        img = $('<img>')
        img.attr('src', 'led-off.png')
        img.attr('onclick', "App.robot_control.update_led_display(#{channel}, #{col+row})")
        img.addClass('position_' + (col+row))
        img.appendTo(div)
