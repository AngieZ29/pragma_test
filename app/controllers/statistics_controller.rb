class StatisticsController < ApplicationController
  def index
    @file_statistics = FileStatistic.all
  end
end
