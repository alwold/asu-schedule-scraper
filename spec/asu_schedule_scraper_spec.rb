require 'asu_schedule_scraper'

describe AsuScheduleScraper do
  scraper = AsuScheduleScraper.new
  # it "can load open class" do
  #   c = get_class :open
  #   c.should be_an_instance_of(ClassInfo)
  #   c.abbrev.should_not be_nil
  # end
  it "open class shows open status" do
    scraper.get_class_status("2137", "89947").should eq(:open)
  end
  it "closed class shows closed status" do
    scraper.get_class_status("2137", "71268")
  end
  it "class info can be loaded" do
    info = scraper.get_class_info('2137', "71268")
    info.name.should eq("First-Year Composition")
    info.schedule.should eq("T Th 10:30 AM - 11:45 AM")
  end
  it "returns nil for non-existent class" do
    scraper.get_class_status("2137", "102938908").should eq(nil)
  end
end

