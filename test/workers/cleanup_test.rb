require 'test_helper'

# tests the cleanup worker
class CleanupTest < ActionController::TestCase
  def setup
  end

  def teardown
  end

  test 'can perform the cleapup operation without errors' do
    cleaner = Utils::Cleanup.new
    cleaner.perform
  end
end
