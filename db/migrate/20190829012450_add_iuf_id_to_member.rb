class AddIufIdToMember < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :iuf_id, :integer
    add_index :members, [:iuf_id], unique: true
  end
end
