require 'test_helper'

# tests select functionality of the nested traverse scraper
class NestedTraverseScraperTest < ActionController::TestCase
  def setup
    @nts = NestedTraverseScraper.new
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
  # test closest_match
  test 'closest match returns nil for exact matches' do
    [SimpleEvent, AthleticEvent, Announcement].each do |model|
      # create model and save it, then create a duplicate
    end
  end

  test 'closest match returns a match when partials exist' do
    [SimpleEvent, AthleticEvent, Announcement].each do |model|
      # create model and save it, then create a duplicate
    end
  end

  test 'closest match returns nil when no matches exist' do
    [SimpleEvent, AthleticEvent, Announcement].each do |model|
      # create model and save it, then create a duplicate
    end
  end
  # test model_crucial_params
  test 'model crucial params returns proper values for each data type' do
    [SimpleEvent, AthleticEvent, Announcement].each do |model|
      params = @nts.model_crucial_params(model.new)
      assert_not_nil params, "returned crucial params for #{model} should not be nil"
      assert params.any?, "#{model} must have crucial params"
    end
  end
  # test model_match_params
  test 'model match params returns proper values for each data type' do
    [SimpleEvent, AthleticEvent, Announcement].each do |model|
      params = @nts.model_match_params(model.new)
      assert_not_nil params, "returned match params for #{model} should not be nil"
      assert params.any?, "#{model} must have match params"
    end
  end
end
