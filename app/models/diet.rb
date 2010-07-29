class Diet < RdfModel::Base
  vocabulary :fishbase => "http://192.168.1.6:8000/vocab/resource/"

  model_type vocab_fishbase.DIET
  id_predicate vocab_fishbase.DIET_autoctr
  name_finder :stage => vocab_fishbase.DIET_Stage

  prefix :diet => "http://lod.fishbase.org/#DIET/"
  id_prefix "http://lod.fishbase.org/#DIET/"

  def name
    vocab_fishbase_DIET_Stage
  end

  def to_param
    vocab_fishbase_DIET_autoctr
  end
end