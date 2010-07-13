class RdfModel::Base
  class << self
    attr_accessor :connection, :prefixes, :vocabularies, :linked_models, :linked_from_models
  end

  def self.inherited(subclass)
    subclass.instance_eval do
      self.connection = FourStore::Store.new(Rails.configuration.triplestore["sparql-uri"])
      self.prefixes = {}
      self.vocabularies = {}
      self.linked_models = {}
      self.linked_from_models = {}
    end
  end

  def self.prefix(prefix, uri)
    self.prefixes[prefix] = uri
  end

  def self.vocabulary(name, uri)
    self.make_string_vocabulary(uri)
    self.vocabularies[name] = uri
  end

  private

  def self.make_string_vocabulary(str)
    class << str
      def method_missing(sym, *args, &block)
        self + sym.to_s
      end
    end
  end

  public

  def self.links_to_model(klass, options)
    self.linked_models[options[:with]] = klass
  end

  def self.linked_from(klass, options)
    self.linked_from_models[options[:with]] = klass
  end

  def self.method_missing(sym, *args, &block)
    return self.vocabularies[$1.to_sym] if sym.to_s =~ /^vocab_(.+)$/ && self.vocabularies[$1.to_sym]
    super(sym, *args, &block)
  end

  def self.respond_to?(sym)
    return !!(sym.to_s =~ /^vocab_(.+)$/ && self.vocabularies[$1.to_sym]) || super(sym)
  end

  def self.sparql_prefix
    prefixes.map {|k,v| "PREFIX #{k}: <#{v}> "}.join("\n")
  end

  def self.sparql(query)
    self.prefixes.each do |name, uri|
      query.gsub!(uri, "#{name}:")
    end
    self.connection.select(self.sparql_prefix + query)
  end

  def self.find_by_uri(uri)
    self.new(uri, self.sparql("SELECT * WHERE { #{uri} ?p ?o }"))
  end

  attr_accessor :attributes, :uri

  def initialize(uri, rdf_data)
    self.uri = uri
    create_attribute_data(rdf_data)
    create_attribute_methods()
    create_linked_from_model_methods()
  end

  private

  def create_attribute_data(rdf_data)
    self.attributes = {}
    rdf_data.each do |rdf_pair|
      predicate = rdf_pair["p"]
      object = rdf_pair["o"]
      self.attributes[predicate] = object
    end
  end

  def create_linked_from_model_methods
    self.class.linked_from_models.each do |predicate, klass|
      self.class.vocabularies.each do |_, vocab|
        self.attributes[predicate] = nil
        self.class.send(:define_method, $1) do
          return self.attributes[predicate] if self.attributes[predicate]
          models = self.class.sparql("SELECT ?uri WHERE { ?uri #{predicate} #{self.uri} }")
          self.attributes[predicate] = models.map {|uri| klass.find_by_uri(uri["uri"])}
        end if predicate =~ /#{vocab}(.*)/
      end
    end
  end

  def create_attribute_methods
    self.attributes.each do |predicate, object|
      self.class.vocabularies.each do |_, vocab|
        if linked_model?(predicate)
          create_linked_model_method(predicate, object, vocab)
        else
          self.class.send(:define_method, $1) {self.attributes[predicate]} if predicate =~ /#{vocab}(.*)/
        end
      end
    end
  end

  def create_linked_model_method(predicate, object, vocab)
    self.attributes[predicate] = nil
    self.class.send(:define_method, $1) do
      return self.attributes[predicate] if self.attributes[predicate]
      self.attributes[predicate] = self.class.linked_models[predicate].find_by_uri(object)
    end if predicate =~ /#{vocab}(.*)/
  end

  def linked_model?(predicate)
    self.class.linked_models[predicate]
  end
end