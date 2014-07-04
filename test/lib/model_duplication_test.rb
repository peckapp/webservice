require 'test_helper'

class ModelDuplicationTest < ActionController::TestCase

  def setup

  end

  def teardown

  end

  test "detect duplicate using model match exists" do

    ModelDuplication.model_match_exists(event,attrs)
  end

  test "detect new object using model match exists" do

    ModelDuplication.model_match_exists(event,attrs)
  end

    test "detect duplicate using model match exists without attributes specified" do

      ModelDuplication.model_match_exists(event)
    end

    test "detect new object using model match exists without attributes specified" do

      ModelDuplication.model_match_exists(event)
    end

  test "prevent save using non duplicative save" do

    ModelDuplication.non_duplicative_save(event,attrs)
  end

  test "allow save using non duplicative save" do

    ModelDuplication.non_duplicative_save(event,attrs)
  end

  test "prevent save using non duplicative save without attributes specified" do

    ModelDuplication.non_duplicative_save(event)
  end

  test "allow save using non duplicative save without attributes specified" do

    ModelDuplication.non_duplicative_save(event)
  end

end
