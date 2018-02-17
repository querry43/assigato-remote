class RobotControlChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'control_channel'
  end

  def get_state
    ActionCable.server.broadcast 'control_channel', RobotState.instance
  end

  def update_state(state)
    RobotState.instance.update(state)
    get_state
  end
end
