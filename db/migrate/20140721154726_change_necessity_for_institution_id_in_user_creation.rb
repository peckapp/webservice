class ChangeNecessityForInstitutionIdInUserCreation < ActiveRecord::Migration
  def up
    change_column("users", "institution_id", :integer, :null => true)
  end

  def down
    change_column("users", "institution_id", :integer, :null => false)
  end
end
