if defined?(Rails::Server)
  Robot.instance.reset_pwm
  Robot.instance.talk({'phrase' => 'Good morning'})
  Robot.instance.display_address
end
