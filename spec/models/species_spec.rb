require 'spec_helper'

describe Species do
  before(:all) do
    Species.connection = mock(FourStore::Store).as_null_object
  end
  it "should find species by species id" do
    Species.connection.should_receive(:select).with("#{Species.sparql_prefix}SELECT * WHERE { species:1 ?p ?o }")
    Species.find_by_id(1)
  end

  it "should have a model prefix" do
    Species.prefixes.should == {:species => "http://lod.fishbase.org/#SPECIES/"}
  end
end