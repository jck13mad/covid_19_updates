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

    if url.include?('foxnews')
      items.each do |item|
        if item.at_css('h4.title a')&.text != nil
          array << { title: item.at_css('h4.title a')&.text, link: item.at_css('h4.title a')&.attribute('href')&.value }
        end
      end
    else
      items.each do |item|
        array << if url.include?('cnbc')
                   { title: item.text.strip.red, link: item.children.attribute('href').value }
                 else
                   { title: item.text.strip.red, link: item.attribute('href').value }
                 end
      end
    end

    array
  end
 end