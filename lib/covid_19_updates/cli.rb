# frozen_string_literal: true

require 'thor'
require 'nokogiri'
require 'open-uri'
require 'colorize'
require_relative 'headlines'
require_relative 'scraper'

module Covid19Updates
  class CLI < Thor
    def self.exit_on_failure
      true
    end

    desc 'start', 'Prints out greeting and basic commands'
    def start
      list
    end

    desc 'start', 'Prints out greeting and basic commands'
    def list
      list_new_networks
      enter_news_network_number
    end

    private

    def cnbc_headline
      array = Headlines.new('https://www.cnbc.com/coronavirus/', 'div.Card-titleContainer').show_headlines

      puts_headlines(array)

      pick

      if @pick.to_i > array.count-1 || @pick.to_i < array.count-1
        puts 
        puts "Sorry, there is no story associated with this number."
        puts
        pick
      end

      Scraper.fetch(array, @pick, 'cnbc')

      continue
    end

    def fox_headline
      array = Headlines.new('https://www.foxnews.com/category/health/infectious-disease/coronavirus', 'header.info-header').show_headlines

      final = array.map! do |item|
        item unless item[:link].start_with?('https')
      end.compact.each do |item|
        item[:link] = item[:link].prepend('https://foxnews.com')
      end

      final.each_with_index do |news, index|
        puts "#{index.succ}: #{news[:title]}".red
      end

      pick
      
      if @pick.to_i > array.count-1 || @pick.to_i < array.count-1
        puts 
        puts "Sorry, there is no story associated with this number."
        puts
        pick
      end

      n = final[@pick.to_i - 1][:link].to_s
      node = Nokogiri::HTML(URI.open(n)).css('p')

      print node[rand(3..(node.count - 2))].text.light_blue
      puts

      continue
    end

    def stat_headline
      array = Headlines.new('https://www.statnews.com/tag/coronavirus/', 'a.topic-block__preview-title').show_headlines

      puts_headlines(array)

      pick

      if @pick.to_i > array.count-1 || @pick.to_i < array.count-1
        puts 
        puts "Sorry, there is no story associated with this number."
        puts
        pick
      end

      Scraper.fetch(array, @pick, 'stat')

      continue
    end

    def continue
      puts ''
      puts ''
      message = ask('Would you like to continue reading updates? (y/n)')

      if message == 'y'
        call
      else
        puts 'Thank you and be safe out there!'.light_blue
      end
    end

    def call
      greeting = <<~DOC
          1. CNBC
          2. FOX NEWS
          3. STAT NEWS
        Enter the number of news website you would like to see updates from.\n Please type cov list to see options or exit to leave.
      DOC
      puts greeting.green.bold

      enter_news_network_number
    end

    def list_new_networks
      greeting = <<~DOC
        Welcome to Covid-19 Updates!
        View the top headlines from the following sites:
            1. CNBC
            2. FOX NEWS
            3. STAT NEWS
          Enter the number of news website you would like to see updates from.\nPlease type list to see options or exit to leave.
      DOC
      puts greeting.cyan.bold
    end

    def enter_news_network_number
      news_net = ask('Enter number assigned to news network')

      case news_net
      when '1'
        cnbc_headline
      when '2'
        fox_headline
      when '3'
        stat_headline
      else
        puts 'No news source by that number.'.red.bold
        puts ''
        puts ''

        call
      end
    end

    def pick
      puts
      @pick = ask('Please pick a number to view an update: ')
      puts
    end

    def puts_headlines(array)
      array.each_with_index do |news, index|
        puts "#{index.succ}: #{news[:title]}"
      end
    end

  end

end
