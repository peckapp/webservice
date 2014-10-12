require 'test_helper'

# tests select functionality of the nested traverse scraper
class NestedTraverseScraperTest < ActionController::TestCase
  def setup
    @nts = NestedTraverseScraper.new
    @set_time = Time.now
  end

  def teardown
  end

  # test methods handling elements with a sample page
  # test handle_element
  # test handle_content_element
  # test handle_foreign_key_element

  # methods handling idempotent saving operations
  # test validate_and_save
  # test idempotent_save

  # test exact_match

  # test closest_partial_match
  test 'closest_partial_match returns nil for exact matches' do
    [SimpleEvent].each do |model|
      # create model and save it, then create a duplicate to test
      params = { institution_id: 1, title: 'test event', event_description: 'description of a test event',
                 location: 'on campus', start_date: @set_time, end_date: @set_time + 1.hours }
      model.create(params)
      new_model = model.new(params)
      match = @nts.closest_partial_match(new_model,
                                         @nts.model_crucial_params(new_model),
                                         @nts.model_crucial_params(new_model))

      assert_nil match, 'if a complete match exists, value should be nil'
    end
  end

  test 'closest match returns a match when partials exist' do
    [SimpleEvent].each do |model|
      # create model and save it, then create a duplicate
    end
  end

  test 'closest match returns nil when no matches exist' do
    [SimpleEvent, AthleticEvent, Announcement].each do |model|
      # create model and save it, then create a duplicate
    end
  end

  ### LOW LEVEL PARAMETERS from the models ###
  # test model_crucial_params
  test 'model crucial params returns proper values for each data type' do
    [SimpleEvent, AthleticEvent, Announcement].each do |model|
      params = @nts.model_crucial_params(model.new)
      assert_not_nil params, "returned crucial params for #{model} should not be nil"
      assert params.any?, "#{model} must have crucial params"

      params.each do |k, _v|
        assert model.column_names.include?(k), 'each key in the params hash must be a column name'
      end
    end
  end
  # test model_match_params
  test 'model match params returns proper values for each data type' do
    [SimpleEvent, AthleticEvent, Announcement].each do |model|
      params = @nts.model_match_params(model.new)
      assert_not_nil params, "returned match params for #{model} should not be nil"
      assert params.any?, "#{model} must have match params"

      params.each do |k, _v|
        assert model.column_names.include?(k), 'each key in the params hash must be a column name'
      end
    end
  end
end
