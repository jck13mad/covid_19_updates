# frozen_string_literal: true

class Headlines

  attr_reader :url, :css_class

  def initialize(url, css_class)
    @url = url
    @css_class = css_class
  end


  def show_headlines
    doc = Nokogiri::HTML(URI.open(url))
    items = doc.css(css_class)



    array = []
    # items.each do |item|
    #   if item&.children&.attribute == nil
    #     array << { title: item.text.strip.red, link: item.attribute('href').value }
    #   else 
    #     array << { title: item.text.red, link: item.children.attribute('href').value }
    #   end
    # end

    if items&.first&.children == nil
      items.each do |item|
        array << { title: item.text.red, link: item.attribute('href').value }
      end
    else
      items.each do |item|
        array << { title: item.text.red, link: item.attribute('href').value }
      end
    end

    array
  end




  # def show_cnbc_headlines
  #   doc = Nokogiri::HTML(URI.open(url))
  #   items = doc.css(css_class)

  #   array = []
  #   items.each do |item|
      
  #     array << { title: item.text.red, link: item.children.attribute('href').value }
  #   end

  #   # binding.irb


  #   array
  # end

  # def show_stat_headlines

  #   doc = Nokogiri::HTML(URI.open(url))
  #   items = doc.css(css_class)

  #   array = []
  #   items.each do |item|
  #     array << { title: item.text.strip.red, link: item.attribute('href').value }
  #   end
  #   binding.irb

  #   array 
  # end

  def show_fox_headlines

    doc = Nokogiri::HTML(URI.open(url))
    items = doc.css(css_class)

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

    array

  end







  # h = Headlines.new("url", "css_class")
  # h.show_headlines



#   doc = Nokogiri::HTML(URI.open('https://www.cnbc.com/coronavirus/'))

#   items = doc.css('div.Card-titleContainer')

#   array = []
#   items.each do |item|
#     array << { title: item.text, link: item.children.attribute('href').value }
#   end

#   doc = Nokogiri::HTML(URI.open('https://www.foxnews.com/category/health/infectious-disease/coronavirus'))
#   items = doc.css('header.info-header')

#   array = []
#   items.each do |item|
#     if item.at_css('h4.title a')&.text != nil
#       array << { title: item.at_css('h4.title a')&.text, link: item.at_css('h4.title a')&.attribute('href')&.value }
#     end
#   end

#   doc = Nokogiri::HTML(URI.open('https://www.statnews.com/tag/coronavirus/'))
#   items = doc.css('a.post-title-link')

#   array = []
#   items.each do |item|
#     array << { title: item.text, link: item.attribute('href').value }
#   end
 end
