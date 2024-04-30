class AddColumnNilPrice < ActiveRecord::Migration[7.0]
  def change
    add_column :file_statistics, :nil_price, :integer
  end
end
