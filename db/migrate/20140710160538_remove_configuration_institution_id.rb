class RemoveConfigurationInstitutionId < ActiveRecord::Migration
  def up
    remove_column("configurations", "institution_id")
  end

  def down
    add_column("configurations", "institution_id")
  end
end
