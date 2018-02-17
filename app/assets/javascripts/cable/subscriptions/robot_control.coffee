App.robot_control = App.cable.subscriptions.create 'RobotControlChannel',
  connected: ->
    console.log 'cable connection established'
    @perform 'get_state'

  disconnected: ->
    console.log 'cable connection lost'

  input: ->
    App.robot_control.update { torso: $('#torso').val() }

  update: (state) ->
    @perform 'update_state', state

  received: (state) ->
    $('#torso').val(state['torso'])
    console.log state
