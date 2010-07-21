class Family < RdfModel::Base
  vocabulary :fishbase => "http://192.168.1.6:8000/vocab/resource/"

  model_type vocab_fishbase.FAMILIES
  id_predicate vocab_fishbase.FAMILIES_FamCode
  name_finder "name" => vocab_fishbase.FAMILIES_CommonName  

  prefix :family => "http://lod.fishbase.org/#FAMILIES/"
  id_prefix "http://lod.fishbase.org/#FAMILIES/"

  linked_from Species, :with => vocab_fishbase.SPECIES_FamCode, :as => "species"

  def name
    vocab_fishbase_FAMILIES_CommonName
  end

  def to_param
    vocab_fishbase_FAMILIES_FamCode
  end
end