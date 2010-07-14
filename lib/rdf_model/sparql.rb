module ::RdfModel::Sparql
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      class << self
        alias :inherited_without_sparql :inherited
        alias :inherited :inherited_with_sparql
      end
    end
  end

  module ClassMethods
    attr_accessor :connection, :id_prefix

    def inherited_with_sparql(subclass)
      subclass.instance_eval do
        self.connection = ::FourStore::Store.new(Rails.configuration.triplestore["sparql-uri"])
      end
      inherited_without_sparql(subclass)
    end
    
    def sparql(query)
      Rails.logger.info("SPARQL Query:\n#{query}\n\n")
      self.connection.select(query)
    end

    def find_by_uri(uri)
      self.new(uri, self.sparql("SELECT * WHERE { #{uri} ?p ?o }"))
    end

    def find_by_id(id)
      self.find_by_uri("#{self.id_prefix}#{id}")
    end
  end
end