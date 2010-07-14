module ::RdfModel::Prefixes
  GLOBAL_PREFIXES = {
          :rdf => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
          :rdfs => "http://www.w3.org/2000/01/rdf-schema#"
  }

  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      class << self
        alias :inherited_without_prefix :inherited
        alias :inherited :inherited_with_prefix
        alias :sparql_without_prefix :sparql
        alias :sparql :sparql_with_prefix
      end
    end
  end

  module ClassMethods
    attr_accessor :prefixes

    def inherited_with_prefix(subclass)
      subclass.instance_eval do
        self.prefixes = {}.merge(::RdfModel::Prefixes::GLOBAL_PREFIXES)
      end
      inherited_without_prefix(subclass)
    end

    def prefix(prefix, uri)
      self.prefixes[prefix] = uri
    end

    def convert_prefixes(query)
      self.prefixes.each do |name, uri|
        query = query.gsub(uri, "#{name}:")
      end
      return query
    end

    def sparql_prefix
      prefixes.map {|k,v| "PREFIX #{k}: <#{v}> "}.join("\n")
    end

    def sparql_with_prefix(query)
      sparql_without_prefix(sparql_prefix + convert_prefixes(query))
    end
  end
end