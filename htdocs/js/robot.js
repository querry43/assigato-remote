var socket = new WebSocket('ws://underdogma.net:3000')

socket.onmessage = (event) => {
  console.log(event)
}

function update_slider() {
  let state = {}
  $('.slider').each( (i, slider) => {
    state[slider.id] = slider.value
  })
  console.log(state)

}
