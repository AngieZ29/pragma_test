class LogFile < ApplicationRecord
  has_many :data_csvs
  has_many :file_statistics
end
