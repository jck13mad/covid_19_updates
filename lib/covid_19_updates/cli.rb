# frozen_string_literal: true

require 'thor'
require 'nokogiri'
require 'open-uri'
require 'colorize'

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
      when '2'
        fox_headline
      when '3'
        cnn_headline
      when '4'
        stat_headline
      else
        puts 'No news source by that number.'
        puts ""
        puts ""
        start
      end
    end

    private

    def cnbc_headline
      doc = Nokogiri::HTML(URI.open('https://www.cnbc.com/coronavirus/'))

      items = doc.css('div.Card-titleContainer')

      array = []
      items.each do |item|
        array << { title: item.text, link: item.children.attribute('href').value }
      end

      array.each_with_index do |news, index|
        puts "#{index.succ}: #{news[:title]}"
      end

      puts
      pick = ask('Please pick a number to view an update: ')
      puts

      print Nokogiri::HTML(URI.open((array[pick.to_i - 1][:link]).to_s)).css('div.group').text.gsub('Â', '')
      puts
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

      print node[rand(3..(node.count))].text
      puts
    end

    # def cnn_headline
    #   doc = Nokogiri::HTML(URI.open('https://www.cnn.com/world/live-news/coronavirus-pandemic-04-26-20-intl/index.html'))
    #   items = doc.css('h2.post-headlinestyles__Headline-sc-2ts3cz-1 gzgZOi').text


    #   binding.irb
      
    #   array = []
    #   items.each do |item|
    #     array << { title: item }
    #   end

    #   array.each_with_index do |news, index|
    #     puts "#{index.succ}: #{news[:title]}"
    #   end

    #   puts
    #     pick = ask('Please pick a number to view an update: ')
    #   puts 

    # end

    def stat_headline
      doc = Nokogiri::HTML(URI.open('https://www.statnews.com/'))
      items = doc.css('span.article-list-title').text

      binding.irb
      
      array = []
      items.each do |item|
        array << { title: item.text, link: item.children.attribute('href').value }
      end

      array.each_with_index do |news, index|
        puts "#{index.succ}: #{news[:title]}"
      end

      puts
      pick = ask('Please pick a number to view an update: ')
      puts

      print Nokogiri::HTML(URI.open((array[pick.to_i - 1][:link]).to_s)).css('a.article-list-link').text
      puts
    end



    def call
      greeting = <<~DOC
        Welcome to Covid-19 Updates!
        View the top headlines from the following sites:

          1. CNBC
          2. FOX NEWS
          3. CNN
          4. STAT NEWS

        Enter the number of news website you would like to see updates from.\n Please type cov list to see options or exit to leave.
      DOC

      puts greeting.green.bold
    end

    def list_new_networks
      greeting = <<~DOC
      Welcome to Covid-19 Updates!
      View the top headlines from the following sites:

          1. CNBC
          2. FOX NEWS
          3. CNN
          4. STAT NEWS

        Enter the number of news website you would like to see updates from.\n Please type list to see options or exit to leave.
      DOC
      puts greeting.cyan.bold
    end
  end
end
