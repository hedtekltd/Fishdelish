class StocksController < ApplicationController
  def index

  end

  def show
    @stock = Stock.find_by_id params[:id]
  end
end