class AddEmailRegexToInstitutions < ActiveRecord::Migration
  def up
    add_column :institutions, :email_regex, :string
  end

  def down
      remove_column :institutions, :email_regex
  end
end
