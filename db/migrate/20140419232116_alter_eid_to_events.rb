class AlterEidToEvents < ActiveRecord::Migration
  def change
    change_column :events, :eid, :string
  end
end
