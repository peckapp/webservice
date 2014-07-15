class CreateResourceTypes < ActiveRecord::Migration
  def change
    create_table :resource_types do |t|
      t.string :info
      t.string :resource_name, null: false
      t.string :model_name,    null: false

      t.timestamps
    end
  end
end
