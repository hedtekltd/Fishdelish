class CommonNamesController < ApplicationController
  def show
    @common_name = CommonName.find_by_id params[:id]
  end

  def index
    @common_names = CommonName.find_all
  end
end