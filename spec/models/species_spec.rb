require 'spec_helper'

describe Species do
  before(:each) do
    Species.connection.stub!(:select).and_return([{"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_SpeciesRefNo", "o"=>"5689"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Length", "o"=>"38"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_VancouverAquarium", "o"=>"0"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_AquariumRef", "o"=>"5595"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Modified", "o"=>"34"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_UsedforAquaculture", "o"=>"never/rarely"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_MTrawls", "o"=>"0"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Expert", "o"=>"34"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_MLiftnets", "o"=>"0"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_MCastnets", "o"=>"0"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Complete", "o"=>"complete"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Aquarium", "o"=>"commercial"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_MSpears", "o"=>"0"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Coordinator", "o"=>"409"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Species", "o"=>"leptosoma"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_MOther", "o"=>"0"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Entered", "o"=>"3"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_MGillnets", "o"=>"0"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_DateModified", "o"=>"1994-09-01T00:00:00"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Saltwater", "o"=>"0"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_DateChecked", "o"=>"1994-03-23T00:00:00"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Subfamily", "o"=>"Pseudocrenilabrinae"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_DemersPelag", "o"=>"demersal"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Source", "o"=>"O"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Author", "o"=>"Regan, 1922"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_FamCode", "o"=>"http://lod.fishbase.org/#FAMILIES/349"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_MTraps", "o"=>"0"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Dangerous", "o"=>"harmless"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_DateEntered", "o"=>"1991-02-25T00:00:00"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Comments", "o"=>"Inhabits the open waters.  Adults regularly encountered near sandy beaches in the shallows.  Piscivore, feeds on small Utaka and Usipa (<i>Engraulicypris sardella</i>) (Ref. 5595)."}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_MDredges", "o"=>"0"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_LTypeMaxM", "o"=>"TL"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Fresh", "o"=>"-1"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Electrogenic", "o"=>"no special ability"}, {"p"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#type", "o"=>"http://192.168.1.6:8000/vocab/resource/SPECIES"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_UsedasBait", "o"=>"never/rarely"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_AquariumFishII", "o"=>"based mainly on breeding"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Genus", "o"=>"Rhamphochromis"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_GameFish", "o"=>"0"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_MaxLengthRef", "o"=>"5689"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_MHooksLines", "o"=>"0"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_SpecCode", "o"=>"2304"}, {"p"=>"http://www.w3.org/2000/01/rdf-schema#label", "o"=>"SPECIES #2304"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_MSeines", "o"=>"0"}, {"p"=>"http://192.168.1.6:8000/vocab/resource/SPECIES_Brack", "o"=>"0"}])    
  end
  
  it "should find species by species id" do
    Species.connection.should_receive(:select).with(/SELECT \?p \?o WHERE { species:1 \?p \?o }/)
    Species.find_by_id(1)
  end

  it "should have a model prefix" do
    Species.prefix.should include({:species => "http://lod.fishbase.org/#SPECIES/"})
  end

  it "should have a vocab prefix" do
    Species.prefix.should include({:vocab_fishbase => "http://192.168.1.6:8000/vocab/resource/"})
  end

  it "should have a fishbase vocabulary" do
    Species.vocabulary[:fishbase].uri.should == "http://192.168.1.6:8000/vocab/resource/"
  end

  it "should create a new species item when searching by id" do
    Species.find_by_id(1).should be_a_kind_of(Species)
  end
end                                            