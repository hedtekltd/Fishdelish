class Family < RdfModel::Base
  prefix :family, "http://lod.fishbase.org/#FAMILIES/"
  prefix :vocab, "http://192.168.1.6:8000/vocab/resource/"
  vocabulary :fishbase, "http://192.168.1.6:8000/vocab/resource/"
  linked_from Species, :with => vocab_fishbase.SPECIES_FamCode
  
end