class Family < RdfModel::Base
  vocabulary :fishbase, "http://192.168.1.6:8000/vocab/resource/"

  self.model_type = vocab_fishbase.FAMILIES
  self.id_finder = vocab_fishbase.FAMILIES_FamCode
  

  prefix :family, "http://lod.fishbase.org/#FAMILIES/"
  prefix :fishbase, vocab_fishbase
  self.id_prefix = "family:"

  linked_from Species, :with => vocab_fishbase.SPECIES_FamCode
end