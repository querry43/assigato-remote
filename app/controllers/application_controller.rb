class ApplicationController < ActionController::Base
  def robot_control
    @letters = Settings.letters.keys
    @led_displays = Settings.led_display
    render action: 'robot_control'
  end
end
