class AddEidToEvents < ActiveRecord::Migration
  def change
    add_column :events, :eid, :integer
  end
end
