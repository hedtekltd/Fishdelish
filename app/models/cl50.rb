class Cl50 < ::RdfModel::Base
  vocabulary :fishbase => "http://192.168.1.6:8000/vocab/resource/"

  model_type vocab_fishbase.CL50

  prefix :cl50 => "http://lod.fishbase.orc/#CL50/"

  def name
    "vocab_fishbase_DIET_Stage"
  end

  def to_param
    "vocab_fishbase_DIET_utoctr"
  end
end