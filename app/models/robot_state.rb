require 'adafruit-servo-driver'

class RobotState
  include Singleton

  attr_reader :torso, :head

  def initialize
    @pwm = self.create_pwm
    @torso = 200
    @head = 20
  end

  def create_pwm
    Rails.configuration.x.enable_hardware ? PWM.new(0x40, true) : nil
  end

  def update_pwm
    return unless Rails.configuration.x.enable_hardware
    @pwm_semaphore ||= Mutex.new
    @pwm_semaphore.synchronize { }
  end

  def update(state)
    ['torso', 'head'].each do |attr|
      if not state[attr].nil? then
        self.instance_variable_set("@#{attr}".to_sym, state[attr])
      end
    end

    self.update_pwm
  end

end
