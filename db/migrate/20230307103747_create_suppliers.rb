class CreateSuppliers < ActiveRecord::Migration[7.0]
  def change
    create_table :suppliers do |t|
      t.float :spend

      t.timestamps
    end
  end
end
