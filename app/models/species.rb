class Species < RdfModel::Base
  prefix :species, "http://lod.fishbase.org/#SPECIES/"
  vocabulary :fishbase, "http://192.168.1.6:8000/vocab/resource/"
  links_to_model Family, :with => "http://192.168.1.6:8000/vocab/resource/SPECIES_FamCode"
  
  def self.find_by_id(id)
    find_by_uri("species:#{id}")
  end
end