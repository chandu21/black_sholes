class AddColumnToOptions < ActiveRecord::Migration
  def change
  	add_column :options, :call_price, :float
    add_column :options, :put_price, :float
  end
end
