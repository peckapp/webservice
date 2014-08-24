require 'test_helper'

class ActiveRecordExtensionTest < ActionController::TestCase

  def setup

  end

  def teardown

  end

  # non_duplicative_save in turn tests model_match_exists because it uses it directly to return both possible results

  test "prevent save using non duplicative save" do
    event = SimpleEvent.find(1)
    # modify event outside of specificed parameters
    event.end_date = event.end_date + 1.hours
    event.description = 'some random description'
    assert event.non_duplicative_save(event, :title => event[:title], :start_date => event[:start_date])
  end

  test "allow save using non duplicative save" do
    event = self.random_event
    assert event.non_duplicative_save(event, :title => event[:title], :start_date => event[:start_date])
  end

  test "prevent save using non duplicative save without attributes specified" do
    event = SimpleEvent.find(1)
    assert event.non_duplicative_save(event)
  end

  test "allow save using non duplicative save without attributes specified" do
    event = self.random_event
    assert event.non_duplicative_save(event)
  end

  test "current or create new for preexisting object" do
    menu_item = MenuItem.find(1)
    result = MenuItem.current_or_create_new(menu_item.attributes)
    assert_equal(menu_item, result)
  end

  test "current or create new for non-existant object" do
    menu_item = self.random_menu_item
    result = MenuItem.current_or_create_new(menu_item.attributes)
    assert_not result.blank?
  end

  private

    def self.random_event
      return SimpleEvent.new(title: "brand new event #{rand(100)}", event_description: "#{rand(100)} is a random number", institution_id: 2, start_date: DateTime.current, end_date: DateTime.now + 1.hour)
    end

    def self.random_menu_item
      return MenuItem.new(name: "menu item #{rand(100)}", category: "category #{rand(10)}", institution_id: rand(Institution.all.count), dining_opportunity_id: 1, dining_place_id: 1, date_available: DateTime.now)
    end

end
