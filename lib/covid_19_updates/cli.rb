


module Covid19Updates
  class CLI < Thor
    desc "greet NAME", "say hello to NAME"
    def greet(name)
      puts "Hello #{name}"
    end
  end
end