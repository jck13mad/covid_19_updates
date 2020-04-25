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
        h = Headlines.scrape_cnbc
        binding.irb
      else
        puts 'No news'
      end
    end

    class Headlines
  
      attr_accessor :name, :url
      extend HeadlinePick
    
      @headlines []
    
      ##CNBC
      def self.scrape_cnbc
        main_url = "https://www.cnbc.com/"
        doc = Nokogiri::HTML(open("https://www.cnbc.com/coronavirus/"))
        puts doc.css("div.PageHeaderWithTuneInText").css("a").text.blue.bold
    
        i = 0
        while i < 3
          cnbc_updates_headline = self.new
          cnbc_updates_headline.name = doc.search("div.Card-titleContainer")[i].text
          cnbc_updates_headline.url = main_url + doc.search("div.Card-titleContainer a").attributes["href"].value
          @headlines << cnbc_updates_headline
          i += 1
        end

      end
    
      ##FOX 
    
      def self.scrape_fox
        main_url = "https://www.foxnews.com/"
        doc = Nokogiri::HTML(open("https://www.foxnews.com/category/health/infectious-disease/coronavirus"))
        puts doc.css("div.page-heading").css("h1").text.blue.bold
    
        i = 0
        while i < 5
          fox_updates_headline = self.new
          fox_updates_headline.name = doc.search("div.content article-list article header")[i].text
          fox_updates_headline.url = main_url + doc.search("div.content article-list article header").attributes["href"].value
          @headlines << fox_updates_headline
          i += 1
        end
      end
    
      ##CNN
      def self.scrape_cnn
        main_url = "https://www.cnn.com/"
        doc = Nokogiri::HTML(open("https://www.cnn.com/us/live-news/us-coronavirus-update-04-24-20/index.html"))
        puts "Coronavirus Updates".blue.bold
    
        i = 0
        while i < 5
          cnn_updates_headline = self.new
          cnn_updates_headline.name = doc.search("div.ls _30cc0dc7 _0fe074fa article header span h2")[i].text
          cnn_updates_headline.url = main_url + doc.search("div.ls _30cc0dc7 _0fe074fa article header span h2").attributes["href"].value
          @headlines << cnn_updates_headline
          i += 1
        end
      end
    
      ##STAT
      def self.scrape_stat
        main_url = "https://www.statnews.com/"
        doc = Nokogiri::HTML(open("https://www.statnews.com/tag/coronavirus/"))
        puts doc.css("div.content-header-inner").css("h1").text.blue.bold
    
        i = 0
        while i < 5
          stat_updates_headline = self.new
          stat_updates_headline.name = doc.search("div.article-info h3 a")[i].text
          stat_updates_headline.url = main_url + doc.search("div.article-info h3 a").attributes["href"].value
          @headlines << stat_updates_headline
          i += 1
        end
      end

    private

    # def cnbc_headline
    #   @headlines = Array.new
    #   main_url = 'https://www.cnbc.com/'
    #   doc = Nokogiri::HTML(open('https://www.cnbc.com/coronavirus/'))
    #   puts doc.css('div.PageHeaderWithTuneInText').css('a').text.blue.bold

    #   i = 0
    #   while i < 3
    #     cnbc_updates_headline = new
    #     cnbc_updates_headline.name = doc.search('div.Card-titleContainer')[i].text
    #     cnbc_updates_headline.url = main_url + doc.search('div.Card-titleContainer a').attributes['href'].value
    #     @headlines << cnbc_updates_headline
    #     i += 1
    #   end

    #   puts @headlines
    # end

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
