Rails.configuration.class_eval do
  attr_accessor :triplestore
end
Rails.configuration.triplestore = YAML.load(File.open(File.join(Rails.root, "config", "triplestore.yml")))[Rails.env]