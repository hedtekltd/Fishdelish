class CommonName < RdfModel::Base
  vocabulary :fishbase, "http://192.168.1.6:8000/vocab/resource/"

  self.model_type = vocab_fishbase.COMNAMES
  self.id_finder = vocab_fishbase.COMNAMES_autoctr
  self.name_finder vocab_fishbase.COMNAMES_Script => "language"
  self.name_finder vocab_fishbase.COMNAMES_ComName => "name"
  self.name_finder vocab_fishbase.COMNAMES_NameType => "name_type"

  prefix :common_name, "http://lod.fishbase.org/#COMNAMES/"
  prefix :fishbase, vocab_fishbase
  self.id_prefix = "common_name:"

  links_to_model Species, :with => vocab_fishbase.COMNAMES_SpecCode

  def common_name
    return self.COMNAMES_ComName if !(self.respond_to? :COMNAMES_UnicodeText) || self.COMNAMES_UnicodeText.blank?
    return self.COMNAMES_UnicodeText
  end
end
