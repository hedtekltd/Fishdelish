class Species < RdfModel::Base
  vocabulary :fishbase, "http://192.168.1.6:8000/vocab/resource/"

  prefix :species, "http://lod.fishbase.org/#SPECIES/"
  prefix :fishbase, vocab_fishbase
  prefix :rdf, "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  prefix :rdfs, "http://www.w3.org/2000/01/rdf-schema#"
  self.id_prefix = "species:"

  links_to_model Family, :with => vocab_fishbase.SPECIES_FamCode
  linked_from CommonName, :with => vocab_fishbase.COMNAMES_SpecCode
end