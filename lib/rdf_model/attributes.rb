module ::RdfModel::Attributes
  def self.included(base)
    base.class_eval do
      alias :initialize_without_attributes :initialize
      alias :initialize :initialize_with_attributes
    end
  end

  attr_accessor :attributes

  def initialize_with_attributes(uri, rdf_data)
    create_attribute_data(rdf_data)
    create_attribute_methods()
    initialize_without_attributes(uri, rdf_data)
  end

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
end