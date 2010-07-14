class CommonName < RdfModel::Base
  vocabulary :fishbase, "http://192.168.1.6:8000/vocab/resource/"

  prefix :common_name, "http://lod.fishbase.org/#COMNAMES/"
  prefix :fishbase, vocab_fishbase
  self.id_prefix = "common_name:"

  links_to_model Species, :with => vocab_fishbase.COMNAMES_SpecCode
end