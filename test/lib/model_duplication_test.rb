require 'test_helper'

class ModelDuplicationTest < ActionController::TestCase

  def setup

  end

  def teardown

  end

  # non_duplicative_save in turn tests model_match_exists because it uses it directly to return both possible results

  test "prevent save using non duplicative save" do
    event = SimpleEvent.find(1)
    assert ModelDuplication.non_duplicative_save(event, :title => event[:title], :start_date => event[:start_date])
  end

  test "allow save using non duplicative save" do
    event = self.random_event
    assert ModelDuplication.non_duplicative_save(event, :title => event[:title], :start_date => event[:start_date])
  end

  test "prevent save using non duplicative save without attributes specified" do
    event = SimpleEvent.find(1)
    assert ModelDuplication.non_duplicative_save(event)
  end

  test "allow save using non duplicative save without attributes specified" do
    event = self.random_event
    assert ModelDuplication.non_duplicative_save(event)
  end

  private

    def self.random_event
      return SimpleEvent.new(title: "brand new event #{rand(100)}", event_description: "#{rand(100)} is a random number", institution_id: 2, start_date: DateTime.current, end_date: DateTime.now + 1.hour)
    end

end
