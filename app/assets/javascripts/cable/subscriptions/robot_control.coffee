App.robot_control = App.cable.subscriptions.create 'RobotControlChannel',
  connected: ->
    console.log 'cable connection established'
    @perform 'get_state'

  disconnected: ->
    console.log 'cable connection lost'

  update: (state) ->
    @perform 'update_state', state

  received: (state) ->
    console.log state
