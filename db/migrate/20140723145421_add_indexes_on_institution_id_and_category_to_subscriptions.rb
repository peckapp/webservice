class AddIndexesOnInstitutionIdAndCategoryToSubscriptions < ActiveRecord::Migration
  def change
    add_index("subscriptions", "category")
    add_index("subscriptions", "institution_id")
  end
end
