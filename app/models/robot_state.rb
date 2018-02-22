require 'adafruit-servo-driver'

class RobotState
  include Singleton

  @@pwm_motor_channels = {
    :head_pan => 2,
    :head_tilt => 4,
    :left_arm => 1,
    :right_arm => 0,
    :torso => 3,
   }

  @@pwm_led_channels = {
    :left_eye_r => 12,
    :left_eye_g => 13,
    :left_eye_b => 14,

    :right_eye_r => 8,
    :right_eye_g => 9,
    :right_eye_b => 10,
  }

  @@pwm_motor_channels.each_key { |key| attr_reader key }
  @@pwm_led_channels.each_key { |key| attr_reader key }

  def initialize
    @@pwm_motor_channels.each_key { |key|
      self.instance_variable_set("@#{key.to_s}".to_sym, 400)
    }

    @@pwm_led_channels.each_key { |key|
      self.instance_variable_set("@#{key.to_s}".to_sym, 4095)
    }

    self.initialize_pwm
    self.update_pwm
  end

  def initialize_pwm
    return unless Rails.configuration.x.enable_hardware
    @pwm = PWM.new(0x40, true)
    @pwm.set_pwm_freq(60)
  end

  def update_pwm
    return unless Rails.configuration.x.enable_hardware

    @pwm_semaphore ||= Mutex.new
    @pwm_semaphore.synchronize {

      @@pwm_motor_channels.merge(@@pwm_led_channels).each do |key, channel|
        @pwm.set_pwm(channel, 0, self.instance_variable_get("@#{key.to_s}".to_sym))
      end

    }
  end

  def update(state)
    @@pwm_motor_channels.merge(@@pwm_led_channels).each_key do |attr|
      if not state[attr.to_s].nil? then
        self.instance_variable_set("@#{attr.to_s}".to_sym, state[attr.to_s].to_i)
      end
    end

    self.update_pwm
  end

end
