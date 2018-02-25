require 'adafruit-servo-driver'

class Robot
  include Singleton

  attr_reader :pwm_channels, :led_displays

  def initialize
    @led_displays = []

    self.init_pwm_value
    self.init_pwm_hardware
    self.update_pwm
    self.init_led_display
    self.update_led_display
  end

  def update(state)
    @pwm_channels.each_key do |key|
      if not state[key.to_s].nil? then
        @pwm_channels[key] = state[key.to_s].to_f
      end
    end

    if state['toggle_led_display'] then
      led = state['toggle_led_display']
      @led_displays[led['channel']][led['position']] = ! @led_displays[led['channel']][led['position']]
    end

    self.update_pwm
    self.update_led_display
  end

  def reset_pwm
    self.init_pwm_value
    self.update_pwm
  end

  def idle_pwm
    return unless Settings.enable_hardware
    @pwm.set_all_pwm(0, 0)
  end

  def talk
    return unless Settings.enable_hardware
    system("espeak -s 120 'hello, my name is assigato,,  i am a robot,, beep boop'")
  end

  protected
  def init_pwm_value
    @pwm_channels = Hash[Settings.pwm_channels.map do |key, val| [key, val['init']] end]
  end

  def init_pwm_hardware
    return unless Settings.enable_hardware
    @pwm = PWM.new(0x40, true)
    @pwm.set_pwm_freq(60)
  end

  def scale_pwm(key, t)
    if Settings.pwm_channels[key][:invert]
      t *= -1
      t += 1
    end
    range = Settings.pwm_channels[key][:high] - Settings.pwm_channels[key][:low]
    return ((range * t) + Settings.pwm_channels[key][:low]).to_i
  end

  def update_pwm
    return unless Settings.enable_hardware

    @pwm_semaphore ||= Mutex.new
    @pwm_semaphore.synchronize {

      @pwm_channels.each do |key, val|
        @pwm.set_pwm(Settings.pwm_channels[key][:channel], 0, self.scale_pwm(key, val))
      end

    }
  end

  def init_led_display
    Settings.led_display.each do |channel|
      @led_displays.push(Array.new(channel[:segments], false))
    end

    return unless Settings.enable_hardware

    require 'rpi_gpio'

    RPi::GPIO.set_numbering :bcm
    RPi::GPIO.set_warnings false

    Settings.led_display.each do |channel|
      [channel[:clock_pin], channel[:data_pin]].each do |pin|
        RPi::GPIO.setup pin, :as => :output, :initialize => :low
      end
    end
  end

  def bitbang(clock_pin, data_pin, data)
    data.each do |b|
      if b
        RPi::GPIO.set_low data_pin
      else
        RPi::GPIO.set_high data_pin
      end

      self.pulse(clock_pin)
    end
  end

  def pulse(pin)
    RPi::GPIO.set_high pin
    RPi::GPIO.set_low pin
  end

  def update_led_display
    return unless Settings.enable_hardware

    @led_displays.each_index do |i|
      self.bitbang(
        Settings.led_display[i][:clock_pin],
        Settings.led_display[i][:data_pin],
        @led_displays[i].reverse,
      )
    end
  end

end
