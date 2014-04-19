class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.time :end_time
      t.string :location
      t.integer :owner
      t.string :timezone
      t.integer :venue

      t.timestamps
    end
  end
end
