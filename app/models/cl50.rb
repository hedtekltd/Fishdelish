class Cl50 < ::RdfModel::Base
  vocabulary :fishbase => "http://192.168.1.6:8000/vocab/resource/"

  model_type vocab_fishbase.CL50
  name_finder :com_name => vocab_fishbase.CL50_CommonName,
              :genus => vocab_fishbase.CL50_Genus

  id_predicate vocab_fishbase.CL50_CL50Code
  

  prefix :cl50 => "http://lod.fishbase.org/#CL50/"
  id_prefix "http://lod.fishbase.org/#CL50/"

  def name
    "#{vocab_fishbase_CL50_CommonName} #{vocab_fishbase_CL50_Genus}"
  end

  def to_param
    vocab_fishbase_CL50_CL50Code
  end
end