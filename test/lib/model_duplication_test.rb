require 'test_helper'

class ModelDuplicationTest < ActionController::TestCase

  def setup

  end

  def teardown

  end

  test "detect duplicate using model match exists" do

    ModelDuplication.model_match_exists(event,hash)
  end

  test "detect new object using model match exists" do

    ModelDuplication.model_match_exists(event,hash)
  end

  test "prevent save using non duplicative save" do

    ModelDuplication.non_duplicative_save(event,hash)
  end

  test "allow save using non duplicative save" do

    ModelDuplication.non_duplicative_save(event,hash)
  end

end
