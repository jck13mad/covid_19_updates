
require "thor"

module Covid19Updates
  class CLI < Thor
    desc 'start', 'Prints out greeting and basic commands"'
    start

    private

    def start
      greeting = <<~DOC
    
      Welcome to Covid-19 Updates!
      View the top headlines from the following sites: 
      
        1. CNBC
        2. FOXNEWS
        3. CNN
        4. APPLE
      DOC

      puts greeting
    end


  end
end