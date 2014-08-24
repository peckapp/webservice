class AddInformationToResourceUrls < ActiveRecord::Migration
  def change
    add_column :resource_urls, :validated, :boolean, default: false
    add_column :resource_urls, :scraped_value, :string
  end
end
