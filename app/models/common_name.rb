class CommonName < RdfModel::Base
  vocabulary :fishbase => "http://192.168.1.6:8000/vocab/resource/"

  model_type vocab_fishbase.COMNAMES
  id_predicate vocab_fishbase.COMNAMES_autoctr
  name_finder({"language" => vocab_fishbase.COMNAMES_Script,
              "name" => vocab_fishbase.COMNAMES_ComName,
              "name_type" => vocab_fishbase.COMNAMES_NameType},
              :order => [:language, :name, :name_type])

  prefix :common_name => "http://lod.fishbase.org/#COMNAMES/",
         :species => "http://lod.fishbase.org/#SPECIES/"
  id_prefix "http://lod.fishbase.org/#COMNAMES/"

  linked_to Species, :with => vocab_fishbase.COMNAMES_SpecCode
  linked_to Stock, :with => vocab_fishbase.COMNAMES_StockCode
  
  def common_name
    return self.vocab_fishbase_COMNAMES_ComName if !(self.respond_to? :vocab_fishbase_COMNAMES_UnicodeText) || self.vocab_fishbase_COMNAMES_UnicodeText.blank?
    return self.vocab_fishbase_COMNAMES_UnicodeText
  end

  def name
    common_name
  end

  def to_param
    vocab_fishbase_COMNAMES_autoctr
  end
end
