class RobotControlChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'control_channel'
  end

  def get_state
    ActionCable.server.broadcast 'control_channel', Robot.instance
  end

  def update_state(state)
    Robot.instance.update(state)
    get_state
  end

  def rest
    Robot.instance.rest
  end
end
