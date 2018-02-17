class RobotState
  include Singleton

  attr_reader :torso, :head

  def initialize
    @torso = 200
    @head = 20
  end

  def update(state)
    ['torso', 'head'].each do |attr|
      if not state[attr].nil? then
        self.instance_variable_set("@#{attr}".to_sym, state[attr])
      end
    end
  end
end
