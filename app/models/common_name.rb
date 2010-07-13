class CommonName < RdfModel::Base
  prefix :common_name, "http://lod.fishbase.org/#COMNAMES/"
  prefix :vocab, "http://192.168.1.6:8000/vocab/resource/"
  vocabulary :fishbase, "http://192.168.1.6:8000/vocab/resource/"
  links_to_model Species, :with => vocab_fishbase.COMNAMES_SpecCode
end