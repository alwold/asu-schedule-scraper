require './lib/asu_schedule_scraper.rb'
#require 'asu_schedule_scraper'

s = AsuScheduleScraper.new
#info = s.get_class_info('2124', '41902')
#puts "Name: " << info.name
#puts "Schedule: " << info.schedule
puts s.get_class_status('2124', '12345').class

info = s.get_class_info('2127' ,'71459')
if info.nil?
  puts "no info"
else
  puts info.name
end
# reserved seats
puts s.get_class_status('2127', '71459')
# closed
puts s.get_class_status('2127', '76757')
# open
puts s.get_class_status('2127', '77058')
# open
puts s.get_class_status('2127', '71465')

puts s.get_class_status('2127', 'cse-2')
