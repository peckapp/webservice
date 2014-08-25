class AddPublicToInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :public, :boolean, default: true
  end
end
