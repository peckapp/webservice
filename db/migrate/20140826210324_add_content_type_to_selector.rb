class AddContentTypeToSelector < ActiveRecord::Migration
  def change
    add_column :selectors, :content_type, :string
  end
end
