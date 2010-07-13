class Species < RdfModel::Base
  prefix :species, "http://lod.fishbase.org/#SPECIES/"
  
  def self.find_by_id(id)
    sparql("SELECT * WHERE { species:#{id} ?p ?o }")
  end
end