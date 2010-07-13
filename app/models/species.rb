class Species < RdfModel::Base
  prefix :species, "http://lod.fishbase.org/#SPECIES/"
  links_to_value :genus, :with => "http://192.168.1.6:8000/vocab/resource/SPECIES_Genus"
  links_to_value :comments, :with => "http://192.168.1.6:8000/vocab/resource/SPECIES_Comments"
  links_to_value :author, :with => "http://192.168.1.6:8000/vocab/resource/SPECIES_Author"
  links_to_value :length, :with => "http://192.168.1.6:8000/vocab/resource/SPECIES_Length"
  links_to_value :subfamily, :with => "http://192.168.1.6:8000/vocab/resource/SPECIES_Subfamily"
  links_to_value :used_as_bait, :with => "http://192.168.1.6:8000/vocab/resource/SPECIES_UsedasBait"
  
  def self.find_by_id(id)
    Species.new(sparql("SELECT * WHERE { species:#{id} ?p ?o }"))
  end
end