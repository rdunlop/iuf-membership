class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :alternate_first_name
      t.string :last_name
      t.string :alternate_last_name
      t.date :birthdate
      t.string :contact_email

      t.timestamps
    end
  end
end
