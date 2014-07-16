require 'test_helper'

class SelectorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "children method valid children for a top level cell" do
    parent = Selector.where(top_level: true).first

    children = parent.children
    assert_not_nil(children, "children should not be nil for this test")

    children.each do |child|
      assert_not(child.top_level, "no child should have top_level set to true")
      assert_not_nil(child, "child should not be null for this test")
      assert_equal(parent.id, child.parent_selector_id, "parent id must be equal to child.parent_selector_id")
    end
  end

  test "proper parent child relationships for selectors using parent and children methods" do
    Selector.where(top_level: true).each do |parent|
      assert_nil( parent.parent_selector_id, "for each top-level object the parent_selector_id must be nil" )

      assert_not_nil( parent.children, "each parent must have children specified in the selector fixtures" )

      children = parent.children

      children.each do |child|
        assert_not_nil(child, "child should not be null for this test")
        # assert_not_nil ( child.parent_selector_id, "each child must have a parent_selector_id" )
        assert_equal( parent, child.parent, "a parent's child's parent must equal the original parent at all times" )
      end
    end
  end

end
