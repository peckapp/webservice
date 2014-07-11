class RemoveConfigurationInstitutionId < ActiveRecord::Migration
  def change
    remove_column("configurations", "institution_id")
  end
end
