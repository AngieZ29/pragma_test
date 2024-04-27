class CreateLogFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :log_files do |t|
      t.string :name_csv

      t.timestamps
    end
  end
end
