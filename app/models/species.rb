class Species < RdfModel::Base
  vocabulary :fishbase => "http://192.168.1.6:8000/vocab/resource/"

  self.model_type = vocab_fishbase.SPECIES
  self.id_finder = vocab_fishbase.SPECIES_SpecCode
  name_finder vocab_fishbase.SPECIES_Genus => "genus"
  name_finder vocab_fishbase.SPECIES_Species => "name"

  prefix :species => "http://lod.fishbase.org/#SPECIES/"
  id_prefix "http://lod.fishbase.org/#SPECIES/"

  linked_to Family, :with => vocab_fishbase.SPECIES_FamCode
  linked_from CommonName, :with => vocab_fishbase.COMNAMES_SpecCode, :as => "common_names"
end