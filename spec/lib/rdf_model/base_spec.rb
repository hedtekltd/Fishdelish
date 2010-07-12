require 'spec_helper'

describe RdfModel::Base do
  it "should open a connection" do
    FourStore::Store.should_receive(:new).and_return(mock(FourStore::Store))
    class TestRdfModel < RdfModel::Base

    end
    TestRdfModel.new
  end
end