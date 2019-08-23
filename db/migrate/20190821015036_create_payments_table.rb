# frozen_string_literal: true

class CreatePaymentsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.references :member, null: false, foreign_key: true
      t.string :order_id
      t.datetime :received_at
      t.integer :amount_cents
      t.string :currency
      t.timestamps
    end
  end
end
