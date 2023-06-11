# frozen_string_literal: true

class AddStartDateToPayment < ActiveRecord::Migration[6.1]
  def change
    add_column :payments, :start_date, :datetime

    reversible do |direction|
      direction.up do
        execute 'UPDATE payments SET start_date = created_at'
      end
    end
  end
end
