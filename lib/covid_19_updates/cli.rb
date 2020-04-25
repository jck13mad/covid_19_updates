
require "thor"

module Covid19Updates
  class CLI < Thor
    def self.exit_on_failure
      true
    end


    desc 'start', 'Prints out greeting and basic commands'
    def start
      call
    end

    desc 'start', 'Prints out greeting and basic commands'
    def list 
      list_new_networks
    end

    desc 'get_headlines NUM', 'Outputs list of heads from news network'
    def get_headlines(number)
      puts "Headlines from "CNBC"
    end

    private

    def call
      greeting = <<~DOC
    
      Welcome to Covid-19 Updates!
      View the top headlines from the following sites: 
      
        1. CNBC
        2. FOXNEWS
        3. CNN
        4. STATNEWS

      Enter the number of news website you would like to see updates from.\n Please type cov list to see options or exit to leave.
      DOC

      puts greeting
    end

    def list_new_networks
      greeting = <<~DOC
        1. CNBC
        2. FOXNEWS
        3. CNN
        4. STATNEWS

      Enter the number of news website you would like to see updates from.\n Please type list to see options or exit to leave.
      DOC
      puts greeting
    end


  end
end