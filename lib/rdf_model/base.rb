class RdfModel::Base
  class << self
    attr_accessor :connection, :prefixes, :values
  end

  def self.inherited(subclass)
    subclass.instance_eval do
      self.connection = FourStore::Store.new(Rails.configuration.triplestore["sparql-uri"])
      self.prefixes = {}
      self.values = {}
    end
  end

  def self.prefix(prefix, uri)
    self.prefixes[prefix] = uri
  end

  def self.sparql_prefix
    prefixes.map {|k,v| "PREFIX #{k}: <#{v}> "}.join("\n")
  end

  def self.sparql(query)
    self.connection.select(self.sparql_prefix + query)
  end

  def self.links_to_value(val_name, options = {})
    self.values[val_name] = options[:with]
  end

  def initialize(rdf_data)
    rdf_data.each do |rdf_pair|
      predicate = rdf_pair["p"]
      object = rdf_pair["o"]
      self.class.values.each do |name, pred|
        if pred == predicate
          self.class.send(:define_method, name) do
            object
          end
        end
      end
    end
  end
end