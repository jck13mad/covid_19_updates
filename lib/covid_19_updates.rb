require "covid_19_updates/version"
require "covid_19_updates/cli"
require "thor"

module Covid19Updates
  class CLI < Thor
    desc "greet NAME", "say hello to NAME"
    def greet(name)
      puts "Hello #{name}"
    end
  end

  class Testing
  end
end


