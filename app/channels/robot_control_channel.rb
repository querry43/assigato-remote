class RobotControlChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'control_channel'
    @state = RobotState.new
  end

  def get_state
    ActionCable.server.broadcast 'control_channel', @state
  end

  def update_state(state)
    @state.update(state)
    get_state
  end
end
