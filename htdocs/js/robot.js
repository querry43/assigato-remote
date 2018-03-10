var robot = {}

robot.socket_location = 'ws://' + document.location.host + ':3000/'

robot.socket = new WebSocket(robot.socket_location)

robot.socket.onmessage = (event) => {
  let robot = JSON.parse(event.data)

  robot.pwm_channels.forEach((pwm_channel) => {
    let element = $("input[data-pwm-channel='" + pwm_channel.channel + "']")
    if (element.length > 0) {
      element.val(pwm_channel.position)
    }
  })

  robot.led_displays.forEach((led_display_channel) => {
    let channel = led_display_channel.channel
    console.log(channel)
    led_display_channel.state.forEach((value, idx) => {
      let pixel = $('.led_pixel[data-led-display-channel="' + channel + '"][data-idx="' + idx + '"]')
      pixel.attr('data-on', value ? 1 : 0)
    })
  })
}

robot.update_slider = function (element, event) {
  let message = {
    PWMChannelState: {
      channel: parseInt(element.dataset.pwmChannel),
      position: parseFloat(element.value),
    }
  }
  robot.socket.send(JSON.stringify(message))
}

robot.speak = function (element, quip) {
  let message = {
    RobotSpeak: {
      quip: quip
    }
  }
  robot.socket.send(JSON.stringify(message))
}

robot.toggle_led = function (element, event) {
  let channel = parseInt(element.dataset.ledDisplayChannel)
  let pixels = $('.led_pixel[data-led-display-channel="' + channel + '"]')
  let state = []

  pixels.each((_, element) => {
    state[parseInt(element.dataset.idx)] = (element.dataset.on == 1 ? true : false)
  })

  state[parseInt(element.dataset.idx)] = (element.dataset.on == 1 ? false : true)

  let message = {
    LEDDisplayState: {
      channel: channel,
      state: state,
    }
  }

  robot.socket.send(JSON.stringify(message))
}

Array(1, 0).forEach((channel) => {
  Array(3, 2, 1, 0).forEach((col) => {
    let div = $('<div class="led_display_col" data-led-display-channel=""></div>')
    $("#led_display_container").append(div)
    Array(0, 1, 2, 3).forEach((row) => {
      let img = $('<div>')
      img.addClass('led_pixel')
      img.attr('data-on', '0')
      img.attr('data-idx', (col*4) + row)
      img.attr('data-led-display-channel', channel)
      img.attr('onclick', 'robot.toggle_led(this, event)')
      div.append(img)
    })
  })
})
