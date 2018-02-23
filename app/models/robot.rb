require 'adafruit-servo-driver'

class Robot
  include Singleton

  attr_reader :pwm_channels

  def initialize
    @pwm_channels = Hash[Settings.pwm_channels.map do |key, val| [key, val['init']] end]

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

      @pwm_channels.each do |key, val|
        @pwm.set_pwm(Settings.pwm_channels[key][:channel], 0, val)
      end

    }
  end

  def update(state)
    @pwm_channels.each_key do |key|
      if not state[key.to_s].nil? then
        @pwm_channels[key] = state[key.to_s].to_i
      end
    end

    self.update_pwm
  end

  def rest
    @pwm.set_all_pwm(0, 0)
  end

end
