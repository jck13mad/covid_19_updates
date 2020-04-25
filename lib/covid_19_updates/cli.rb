# frozen_string_literal: true

require 'thor'
require 'nokogiri'
require 'open-uri'

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

      news_net = ask('Enter number assigned to news network')

      case news_net
      when '1'
        cnbc_headline
      else
        puts 'No news'
      end
    end

    private

    def cnbc_headline
      @headlines = Array.new
      main_url = 'https://www.cnbc.com/'
      doc = Nokogiri::HTML(open('https://www.cnbc.com/coronavirus/'))
      puts doc.css('div.PageHeaderWithTuneInText').css('a').text.blue.bold

      i = 0
      while i < 3
        cnbc_updates_headline = new
        cnbc_updates_headline.name = doc.search('div.Card-titleContainer')[i].text
        cnbc_updates_headline.url = main_url + doc.search('div.Card-titleContainer a').attributes['href'].value
        @headlines << cnbc_updates_headline
        i += 1
      end

      puts @headlines
    end

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
