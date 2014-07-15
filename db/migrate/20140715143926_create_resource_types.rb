class CreateResourceTypes < ActiveRecord::Migration
  def change
    create_table :resource_types do |t|
      t.info :string
      t.resource_name :string, null: false
      t.model_name :string,    null: false

      t.timestamps
    end
  end
end
