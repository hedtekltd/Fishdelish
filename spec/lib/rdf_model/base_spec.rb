require 'spec_helper'

describe RdfModel::Base do

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

  it "should query the triplestore with SPARQL queries" do
    sparql_query = "SELECT ?subject ?predicate ?object"
    @store.should_receive(:select).with(sparql_query)
    test_class.sparql(sparql_query)
  end

  it "should provide the connection to the triplestore" do
    test_class.connection.should == @store 
  end

  it "should allow the definition of prefixes" do
    c = test_class
    c.prefix :test, "http://test.host/vocab"
    c.prefixes.should == {:test => "http://test.host/vocab"}
    c.sparql_prefix.should == "PREFIX test: <http://test.host/vocab> "
  end

  it "should add the prefix onto the start of a sparql query" do
    c = test_class
    c.prefix :test, "http://test.host/vocab"
    sparql_query = "SELECT * WHERE {?s ?o ?p}"
    @store.should_receive(:select).with("PREFIX test: <http://test.host/vocab> #{sparql_query}")
    c.sparql(sparql_query)
  end

  it "should allow the definition of value links" do
    c = test_class
    c.links_to_value :test_val, :with => "http://test.host/vocab/test_predicate"
    t = c.new([{"p" => "http://test.host/vocab/test_predicate", "o" => "testing"}])
    t.test_val.should == "testing"
  end
end