require 'test_helper'

class ModelDuplicationTest < ActionController::TestCase

  def setup

  end

  def teardown

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
