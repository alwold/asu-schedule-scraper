require 'net/http'
require 'nokogiri'
require_relative 'asu_class_info'

class AsuScheduleScraper
  def get_class_info(term_code, class_number)
    doc = fetch_info(term_code, class_number)
    name = string_value doc.xpath("//tr[td/@class='classNbrColumnValue']/td[@class='titleColumnValue']/a/text()")[0]
    days = string_value doc.xpath("//tr[td/@class='classNbrColumnValue']/td[@class='dayListColumnValue']/text()")[0]
    start_time = string_value doc.xpath("//tr[td/@class='classNbrColumnValue']/td[@class='startTimeDateColumnValue']/text()")[0]
    end_time = string_value doc.xpath("//tr[td/@class='classNbrColumnValue']/td[@class='endTimeDateColumnValue']/text()")[0]
    if name != nil
      AsuClassInfo.new(name, days << " " << start_time << " " << end_time)
    else
      nil
    end
  end

  def get_class_status(term_code, class_number)
    doc = fetch_info(term_code, class_number)
    rel = doc.xpath("//tr[td/@class='classNbrColumnValue']/td[@class='availableSeatsColumnValue']/table/tr/td/span/span[@class='icontip']")[0].attributes["rel"].value
    if rel == "#tt_seats-open" then
      :open
    elsif rel == "#tt_seats-reserved" then
      :closed
    elsif rel == "#tt_seats-closed" then
      :closed
    else
      raise Error("Unknown status")
    end
  end

private
  def string_value(node)
    if node == nil
      nil
    else
      node.to_s.strip
    end
  end

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
    doc = Nokogiri::HTML(res.body)
    # this somehow makes decoding of entities work (https://twitter.com/#!/tenderlove/status/11489447561)
    doc.encoding = "UTF-8"
    return doc
  end
end
