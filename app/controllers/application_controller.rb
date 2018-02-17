class ApplicationController < ActionController::Base
  def robot_control
    render action: 'robot_control'
  end
end
