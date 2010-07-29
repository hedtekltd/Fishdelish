class DietsController < ApplicationController
  def index
    @diets = Diet.find_all
  end

  def show
    @diet = Diet.find_by_id(params[:id])
  end
end