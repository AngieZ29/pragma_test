class CreateFileStatistics < ActiveRecord::Migration[7.0]
  def change
    create_table :file_statistics do |t|
      t.integer :total_rows
      t.float :avg_price
      t.integer :min_price
      t.integer :max_price
      t.references :log_file, null: false, foreign_key: true

      t.timestamps
    end
  end
end
