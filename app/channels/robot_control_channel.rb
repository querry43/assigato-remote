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

  def reset_pwm
    Robot.instance.reset_pwm
    get_state
  end

  def idle_pwm
    Robot.instance.idle_pwm
  end

  def talk
    Robot.instance.talk
  end
end
