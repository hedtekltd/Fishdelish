class FamiliesController < ApplicationController
  def index
    @families = Family.find_all
  end

  def show
    @family = Family.find_by_id(params[:id])
  end
end