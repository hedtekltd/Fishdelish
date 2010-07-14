require 'spec_helper'

describe RdfModel::Base do

  def prefix_string
    "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> \nPREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> "
  end

  def prefix_hash
    {rdf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#", rdfs: "http://www.w3.org/2000/01/rdf-schema#"}
  end

  def test_class
    Class.new(RdfModel::Base)
  end
  
  before(:each) do
    FourStore::Store.stub!(:new).and_return(@store = mock(FourStore::Store))
  end

  it "should load the connection string from the yaml file" do
    FourStore::Store.should_receive(:new).with(Rails.configuration.triplestore["sparql-uri"])
    test_class
  end

  it "should have rdf and rdfs as prefixes automatically" do
    c = test_class
    c.prefixes.should == prefix_hash
  end

  it "should query the triplestore with SPARQL queries" do
    sparql_query = "SELECT ?subject ?predicate ?object"
    @store.should_receive(:select).with("#{prefix_string}#{sparql_query}")
    test_class.sparql(sparql_query)
  end

  it "should provide the connection to the triplestore" do
    test_class.connection.should == @store 
  end

  it "should allow the addition of known vocabularies" do
    c = test_class
    v = c.vocabulary :test, "http://test.host/vocab/"
    c.vocabularies.should == {:test => v}
    c.vocab_test.should == v
    c.respond_to?(:vocab_test).should == true
  end

  it "should give a vocabulary URI when requested" do
    c = test_class
    c.vocabulary :test, "http://test.host/vocab/"
    c.vocab_test.test_predicate.should == "http://test.host/vocab/test_predicate"
  end

  it "should use the vocabularies to define values" do
    c = test_class
    c.vocabulary :test, "http://test.host/vocab/"
    t = c.new("", [{"p" => "http://test.host/vocab/test_predicate", "o" => "testing"}])
    t.test_predicate.should == "testing"
  end

  it "should allow multiple versions of the dynamic methods to exist" do
    c = test_class
    c.vocabulary :test, "http://test.host/vocab/"
    t1 = c.new("", [{"p" => "http://test.host/vocab/test_predicate", "o" => "testing"}])
    t2 = c.new("", [{"p" => "http://test.host/vocab/test_predicate", "o" => "testing2"}])
    t1.test_predicate.should == "testing"
    t2.test_predicate.should == "testing2"
  end

  it "should create an predicate-object attributes map from the passed in data" do
    c = test_class
    t = c.new("", [{"p" => "http://test.host/vocab/test_predicate", "o" => "testing"}])
    t.attributes.should == {"http://test.host/vocab/test_predicate" => "testing"}
  end

  it "should replace URIs with prefixes where available" do
    c = test_class
    c.prefix :test, "http://test.host/vocab/"

    @store.should_receive(:select).with("#{prefix_string}\nPREFIX test: <http://test.host/vocab/> SELECT * WHERE { test:12 ?p ?o }").and_return([{"p" => "testing", "o" => "testing again"}])
    c.find_by_uri "http://test.host/vocab/12"
  end

  it "should allow the definition of prefixes" do
    c = test_class
    c.prefix :test, "http://test.host/vocab"
    c.prefixes.should == {test: "http://test.host/vocab"}.merge(prefix_hash)
    c.sparql_prefix.should == "#{prefix_string}\nPREFIX test: <http://test.host/vocab> "
  end

  it "should add the prefix onto the start of a sparql query" do
    c = test_class
    c.prefix :test, "http://test.host/vocab"
    sparql_query = "SELECT * WHERE {?s ?p ?o}"
    @store.should_receive(:select).with("#{prefix_string}\nPREFIX test: <http://test.host/vocab> #{sparql_query}")
    c.sparql(sparql_query)
  end

  it "should allow sparql lookup via URI" do
    c = test_class
    @store.should_receive(:select).with("#{prefix_string}SELECT * WHERE { test:1 ?p ?o }").and_return([{"p" => "testing", "o" => "testing again"}])
    t = c.find_by_uri("test:1")
    t.class.should == c
  end

  it "should allow the linking of models" do
    @store.stub!(:select).and_return(["uri" => "http://test.host/vocab/12"], [{"p" => "testing", "o" => "testing again"}])
    c = test_class
    c.vocabulary :test, "http://test.host/vocab/"
    b = test_class
    c.links_to_model b, :with => c.vocab_test.test_link
    c.new("", [{"p" => "test1", "o" => "testing"}, {"p" => c.vocab_test.test_link, "o" => "12"}]).test_link.class.should == b
  end

  it "should store the URI when created" do
    @store.stub!(:select).and_return([{"p" => "http://test.host/vocab/testing", "o" => "more tests"}])
    c = test_class
    c.find_by_uri("http://test.host/vocab/12").uri.should == "http://test.host/vocab/12"

  end

  it "should allow you to create inverse links" do
    @store.stub!(:select).and_return([{"p" => "http://test.host/vocab/testing", "o" => "more tests"}])
    c = test_class
    c.vocabulary :test, "http://test.host/vocab/"
    b = test_class
    b.vocabulary :test, "http://test.host/vocab/"
    c.linked_from b, :with => c.vocab_test.test_link
    c.new("", [{"p" => "test1", "o" => "testing"}]).test_link[0].testing.should == "more tests"
  end

  it "should allow you to search by id" do
    @store.stub!(:select).and_return([{"p" => "http://test.host/vocab/testing", "o" => "more tests"}])
    c = test_class
    c.id_prefix = "testing:"
    @store.should_receive(:select).with("#{prefix_string}SELECT * WHERE { testing:1 ?p ?o }")
    c.find_by_id(1)
  end
end