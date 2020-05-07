class Scraper
  def self.fetch(array, pick, network)
    case network
    when 'cnbc'
      print Nokogiri::HTML(URI.open((array[pick.to_i - 1][:link]).to_s)).css('div.group').text.gsub('Â', '').light_blue
      puts
    when 'stat'
      print Nokogiri::HTML(URI.open((array[pick.to_i - 1][:link]).to_s)).css('a.post-title-link').text.light_blue
      puts
    end
  end
end