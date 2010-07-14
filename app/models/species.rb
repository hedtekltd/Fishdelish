class Species < RdfModel::Base
  vocabulary :fishbase, "http://192.168.1.6:8000/vocab/resource/"

  self.model_type = vocab_fishbase.SPECIES
  self.id_finder = vocab_fishbase.SPECIES_SpecCode
  name_finder vocab_fishbase.SPECIES_Genus => "genus"
  name_finder vocab_fishbase.SPECIES_Species => "name"

  prefix :species, "http://lod.fishbase.org/#SPECIES/"
  prefix :fishbase, vocab_fishbase
  self.id_prefix = "species:"

  links_to_model Family, :with => vocab_fishbase.SPECIES_FamCode
  linked_from CommonName, :with => vocab_fishbase.COMNAMES_SpecCode
end