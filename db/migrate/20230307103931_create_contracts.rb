class CreateContracts < ActiveRecord::Migration[7.0]
  def change
    create_table :contracts do |t|
      t.string :name
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :supplier, null: false, foreign_key: true

      t.timestamps
    end
  end
end
