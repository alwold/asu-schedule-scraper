Gem::Specification.new do |s|
  s.name = "asu-schedule-scraper"
  s.version = "0.1"
  s.date = "2012-03-27"
  s.authors = ["Al Wold"]
  s.email = "alwold@gmail.com"
  s.summary = "Scrapes schedule data for Arizona State University"
  s.files = ["lib/asu_schedule_scraper.rb", "lib/asu_class_info.rb", "AddTrustExternalCARoot.crt"]
  s.add_runtime_dependency "nokogiri"
end