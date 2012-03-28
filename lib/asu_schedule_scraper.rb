require 'net/http'
require 'nokogiri'

class AsuScheduleScraper
  def get_class_info(term_code, class_number)
    doc = fetch_info(term_code, class_number)
    name = doc.xpath("//tr[td/@class='classNbrColumnValue']/td[@class='titleColumnValue']/a/text()")[0].to_s.strip
    days = doc.xpath("//tr[td/@class='classNbrColumnValue']/td[@class='dayListColumnValue']/text()")[0].to_s.strip
    start_time = doc.xpath("//tr[td/@class='classNbrColumnValue']/td[@class='startTimeDateColumnValue']/text()")[0].to_s.strip
    end_time = doc.xpath("//tr[td/@class='classNbrColumnValue']/td[@class='endTimeDateColumnValue']/text()")[0].to_s.strip
puts "name: " << name
puts "days: " << days
puts "start_time: " << start_time
puts "end_time: " << end_time
  end

  private

  def fetch_info(term_code, class_number)
    uri = URI("https://webapp4.asu.edu/catalog/classlist?&k=" << class_number << "&t=" << term_code + "&e=all&init=false&nopassive=true")
    req = Net::HTTP::Get.new(uri.request_uri)
    cookie = "onlineCampusSelection=C"
    req["Cookie"] = cookie
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.ca_file = File.join(File.dirname(File.dirname(__FILE__)), "AddTrustExternalCARoot.crt")
    res = http.start do |http| 
      res = http.request(req)
      if res.code == "302" then
        req = Net::HTTP::Get.new(res["Location"])
        new_cookie = res["Set-Cookie"]
        new_cookie = new_cookie[0..new_cookie.index(";")]
        req["Cookie"] = cookie << "; " << new_cookie
        res = http.request(req)
      end
      res
    end
    Nokogiri::HTML(res.body)
  end
end
