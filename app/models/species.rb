class Species < RdfModel::Base
  prefix :species, "http://lod.fishbase.org/#SPECIES/"
  prefix :vocab, "http://192.168.1.6:8000/vocab/resource/"
  vocabulary :fishbase, "http://192.168.1.6:8000/vocab/resource/"
  links_to_model Family, :with => vocab_fishbase.SPECIES_FamCode
  linked_from CommonName, :with => vocab_fishbase.COMNAMES_SpecCode

  
  def self.find_by_id(id)
    find_by_uri("species:#{id}")
  end
end