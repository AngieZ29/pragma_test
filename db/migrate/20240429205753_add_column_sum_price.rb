class AddColumnSumPrice < ActiveRecord::Migration[7.0]
  def change
    add_column :file_statistics, :sum_price, :integer
  end
end
