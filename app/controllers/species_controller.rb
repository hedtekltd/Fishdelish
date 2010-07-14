class SpeciesController < ApplicationController
  def index
    @species_list = Species.find_all
  end

  def show
    @species = Species.find_by_id(params[:id])
  end
end