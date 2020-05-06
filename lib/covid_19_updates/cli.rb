# frozen_string_literal: true

require 'thor'
require 'nokogiri'
require 'open-uri'
require 'colorize'
require_relative 'headlines'

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
        puts ""
        puts ""
        call
      end
    end

    private

    def cnbc_headline

      array = Headlines.new('https://www.cnbc.com/coronavirus/', 'div.Card-titleContainer').show_cnbc_headlines

      array.each_with_index do |news, index|
        puts "#{index.succ}: #{news[:title]}"
      end

      puts
      pick = ask('Please pick a number to view an update: ')
      puts

      print Nokogiri::HTML(URI.open((array[pick.to_i - 1][:link]).to_s)).css('div.group').text.gsub('Â', '').light_blue
      puts

     continue
    end

    def fox_headline
      doc = Nokogiri::HTML(URI.open('https://www.foxnews.com/category/health/infectious-disease/coronavirus'))
      items = doc.css('header.info-header')

      array = []
      items.each do |item|
        if item.at_css('h4.title a')&.text != nil
          array << { title: item.at_css('h4.title a')&.text, link: item.at_css('h4.title a')&.attribute('href')&.value }
        end
      end

      final = array.map! do |item|
        item unless item[:link].start_with?('https')
      end.compact.each do |item|
        item[:link] = item[:link].prepend('https://foxnews.com')
      end

      final.each_with_index do |news, index|
        puts "#{index.succ}: #{news[:title]}"
      end

      puts
        pick = ask('Please pick a number to view an update: ')
      puts


      # n.css('p')[rand(3..(n.css('p').count))].text (n.css('p').count)
      n = final[pick.to_i - 1][:link].to_s
      node = Nokogiri::HTML(URI.open(n)).css('p')

      print node[rand(3..(node.count-4))].text.light_blue
      puts

     continue
    end

    def stat_headline
      # doc = Nokogiri::HTML(URI.open('https://www.statnews.com/tag/coronavirus/'))
      # items = doc.css('a.topic-block__preview-title')


      # array = []
      # items.each do |item|
      #   array << { title: item.text.strip.red, link: item.attribute('href').value }
      # end
      array = Headlines.new('https://www.statnews.com/tag/coronavirus/', 'a.topic-block__preview-title').show_stat_headlines

      array.each_with_index do |news, index|
        puts "#{index.succ}: #{news[:title]}"
      end

      puts
        pick = ask('Please pick a number to view an update: ')
      puts

      print Nokogiri::HTML(URI.open((array[pick.to_i - 1][:link]).to_s)).css('a.post-title-link').text.light_blue
      puts

      continue
    end

    def continue
      puts ""
      puts ""
      message = ask('Would you like to continue reading updates? (y/n)') 

      if message == "y"
        call
      else
        puts "Thank you and be safe out there!".light_blue
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
        puts ""
        puts ""
        call
      end
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
  end
end
