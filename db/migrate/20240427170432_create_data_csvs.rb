class CreateDataCsvs < ActiveRecord::Migration[7.0]
  def change
    create_table :data_csvs do |t|
      t.date :timestamp
      t.integer :price
      t.integer :user_id
      t.references :log_file, null: false, foreign_key: true

      t.timestamps
    end
  end
end
