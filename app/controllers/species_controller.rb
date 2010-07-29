class SpeciesController < ApplicationController
  def index
    @species_list = Species.find_all
  end

  def show
    @spec_data = Species.species_data_by_id(params[:id])
    @species = Species.find_by_id(params[:id])
  end
end