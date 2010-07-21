class Stock < RdfModel::Base
  vocabulary :fishbase => "http://192.168.1.6:8000/vocab/resource/"

  model_type vocab_fishbase.STOCKS

  prefix :stock => "http://lod.fishbase.org/#STOCKS/",
         :common_name => "http://lod.fishbase.org/#COMNAMES/",
         :species => "http://lod.fishbase.org/#SPECIES/"
  id_prefix "http://lod.fishbase.org/#STOCKS/"

  linked_from CommonName, :with => vocab_fishbase.COMNAMES_StockCode, :as => "common_names"
  linked_to Species, :with => vocab_fishbase.STOCKS_SpecCode

  def name
    vocab_fishbase_STOCKS_LocalUnique
  end

  def to_param
    vocab_fishbase_STOCKS_StockCode
  end
end