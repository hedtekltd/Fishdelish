module ::RdfModel::Associations

  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      alias :initialize_without_associations :initialize
      alias :initialize :initialize_with_associations
      class << self
        alias :inherited_without_associations :inherited
        alias :inherited :inherited_with_associations
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

  def initialize_with_associations(uri, rdf_data)
    create_linked_from_model_methods()
    initialize_without_associations(uri, rdf_data)
  end

  module ClassMethods
    attr_accessor :linked_models, :linked_from_models

    def inherited_with_associations(subclass)
      subclass.instance_eval do
        self.linked_models = {}
        self.linked_from_models = {}
      end
      inherited_without_associations(subclass)
    end
    
    def links_to_model(klass, options)
      self.linked_models[options[:with]] = klass
    end

    def linked_from(klass, options)
      self.linked_from_models[options[:with]] = klass
    end
  end
end