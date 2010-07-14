class SpeciesController < ApplicationController
  def index
    @species_list = Species.sparql("SELECT ?id ?genus ?name WHERE { ?species rdf:type fishbase:SPECIES ; fishbase:SPECIES_SpecCode ?id ; fishbase:SPECIES_Genus ?genus ; fishbase:SPECIES_Species ?name ; }")
  end

  def show
    @species = Species.find_by_id(params[:id])
  end
end