module ::RdfModel::Types

  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      class << self
        alias :inherited_without_types :inherited
        alias :inherited :inherited_with_types
      end
    end
  end

  module ClassMethods
    attr_accessor :model_type, :name_finders, :id_finder

    def inherited_with_types(subclass)
      subclass.instance_eval do
        self.name_finders = {}
      end
      inherited_without_types(subclass)
    end

    def name_finder(hash)
      name_finders.merge!(hash)
    end

    def find_all
      type_sparql = "?type rdf:type #{self.model_type}"
      id_sparql = " ; #{id_finder} ?id"
      name_sparql = name_finders.map {|k, v| " ; #{k} ?#{v}"}.join('')
      selector = "?id #{name_finders.values.map {|v| "?#{v}"}.join(' ')}"
      sparql("SELECT #{selector} WHERE { #{type_sparql}#{id_sparql}#{name_sparql} }")
    end
  end
end