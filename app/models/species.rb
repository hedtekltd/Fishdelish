class Species < RdfModel::Base
  vocabulary :fishbase, "http://192.168.1.6:8000/vocab/resource/"

  prefix :species, "http://lod.fishbase.org/#SPECIES/"
  prefix :fishbase, vocab_fishbase
  self.id_prefix = "species:"

  links_to_model Family, :with => vocab_fishbase.SPECIES_FamCode
  linked_from CommonName, :with => vocab_fishbase.COMNAMES_SpecCode

  def self.find_all
    sparql("SELECT ?id ?genus ?name WHERE { ?species rdf:type fishbase:SPECIES ; fishbase:SPECIES_SpecCode ?id ; fishbase:SPECIES_Genus ?genus ; fishbase:SPECIES_Species ?name ; }")
  end
end