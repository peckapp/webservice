class AddSimpleNameColumnToAthleticTeams < ActiveRecord::Migration
  def change
    add_column :athletic_teams, :simple_name, :string
  end
end
