class Species < RdfModel::Base
  vocabulary :fishbase => "http://192.168.1.6:8000/vocab/resource/"

  model_type vocab_fishbase.SPECIES
  id_predicate vocab_fishbase.SPECIES_SpecCode
  name_finder({"genus" => vocab_fishbase.SPECIES_Genus,
              "name" => vocab_fishbase.SPECIES_Species},
              :order => [:genus, :name])

  prefix :species => "http://lod.fishbase.org/#SPECIES/",
         :family => "http://lod.fishbase.org/#FAMILIES/"
  id_prefix "http://lod.fishbase.org/#SPECIES/"

  linked_to Family, :with => vocab_fishbase.SPECIES_FamCode
  linked_from CommonName, :with => vocab_fishbase.COMNAMES_SpecCode, :as => "common_names"
  linked_from Stock, :with => vocab_fishbase.STOCKS_SpecCode, :as => "stocks"

  def name
    "#{vocab_fishbase_SPECIES_Genus} #{vocab_fishbase_SPECIES_Species}"
  end

  def to_param
    vocab_fishbase_SPECIES_SpecCode
  end

  def self.species_data_by_id(id)
    id_pred = id_prefix + id.to_s
    species = "#{id_pred} #{vocab_fishbase.SPECIES_Species} ?spec_name; #{vocab_fishbase.SPECIES_Genus} ?genus_name; #{vocab_fishbase.SPECIES_Author} ?author; #{vocab_fishbase.SPECIES_Comments} ?comments; #{vocab_fishbase.SPECIES_Subfamily} ?subfamily. "
    common_name = "?com_name #{vocab_fishbase.COMNAMES_SpecCode} #{id_pred}; #{vocab_fishbase.COMNAMES_Language} 'English'; #{vocab_fishbase.COMNAMES_ComName} ?english_name. OPTIONAL { ?com_name #{vocab_fishbase.COMNAMES_Remarks} ?comname_remarks }. "
    family = "#{id_pred} #{vocab_fishbase.SPECIES_FamCode} ?family. ?family #{vocab_fishbase.FAMILIES_CommonName} ?fam_common_name; #{vocab_fishbase.FAMILIES_Order} ?order; #{vocab_fishbase.FAMILIES_Family} ?fam_name. "
    
    find_by_sparql("SELECT * WHERE {#{species} #{common_name} #{family}}")
  end
end