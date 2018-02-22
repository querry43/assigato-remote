# deduping this list requires rendering this through a controller
App.robot_pwm_channels = [
  'head_pan',
  'head_tilt',
  'left_arm',
  'right_arm',
  'torso',

  'left_eye_r',
  'left_eye_g',
  'left_eye_b',

  'right_eye_r',
  'right_eye_g',
  'right_eye_b'
]

App.robot_control = App.cable.subscriptions.create 'RobotControlChannel',
  connected: ->
    console.log 'cable connection established'
    @perform 'get_state'

  disconnected: ->
    console.log 'cable connection lost'

  input: ->
    state = {}
    App.robot_pwm_channels.forEach (channel) -> state[channel] = $('#' + channel).val()
    App.robot_control.update state

  update: (state) ->
    @perform 'update_state', state

  received: (state) ->
    App.robot_pwm_channels.forEach (channel) -> $('#' + channel).val(state['pwm_channels'][channel])
