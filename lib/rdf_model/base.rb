class ::RdfModel::Base
  attr_accessor :uri

  def initialize(uri, rdf_data)
    self.uri = uri
  end

  include ::RdfModel::Sparql
  include ::RdfModel::Types
  include ::RdfModel::Associations
  include ::RdfModel::Attributes
  include ::RdfModel::Prefixes
  include ::RdfModel::Vocabularies
end