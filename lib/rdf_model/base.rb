class RdfModel::Base
  class << self
    attr_accessor :connection, :prefixes
  end

  def self.inherited(subclass)
    subclass.instance_eval do
      self.connection = FourStore::Store.new(Rails.configuration.triplestore["sparql-uri"])
      self.prefixes = {}
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
end