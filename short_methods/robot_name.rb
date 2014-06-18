class NameCollisionError < RuntimeError; end;

class Robot
  attr_accessor :name

  @@registry

  def initialize(args = {})
    @@registry ||= []
    if @name_generator = args[:name_generator]
      @name = @name_generator.call
    else
      defineName
    end
    validateName
    @@registry << @name
  end

  def defineName
    generate_char = -> { ('A'..'Z').to_a.sample }
    generate_num = -> { rand(10) }
    @name = "#{generate_char.call}#{generate_char.call}#{generate_num.call}"\
      "#{generate_num.call}#{generate_num.call}"
    puts @name
  end

  def validateName
    unless (@name =~ /\w{2|\d{3}/) || @@registry.include?(@name)
      raise NameCollisionError, 'There was a probelm generating the robot name!'
    end
  end

end

robot = Robot.new
puts "My pet robot's name is #{robot.name}, but we usually call him sparky."

# Errors!
# generator = -> { 'AA111' }
# Robot.new(name_generator: generator)
# Robot.new(name_generator: generator)
