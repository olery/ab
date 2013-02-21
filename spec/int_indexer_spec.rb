require 'spec_helper'

describe Ab::Indexer do
  let(:indexer){ Ab::Indexer }


  it "should process a bunch of options" do
    options = [
      {:chances=>[100,0],   :value=>123, :result=>0, :seed=>123},
      {:chances=>[0,100],   :value=>123, :result=>1, :seed=>123},
      {:chances=>[-10,100], :value=>123, :result=>1, :seed=>123},
      {:chances=>[100,0,0], :value=>123, :result=>0, :seed=>123},
      {:chances=>[0,100,0], :value=>123, :result=>1, :seed=>123},
      {:chances=>[0,0,100], :value=>123, :result=>2, :seed=>123},
    ]

    options.each do |option|
      indexer.call(option).should eql(option[:result])
    end

  end

  it "raises ArgumentError when arguments are missing" do
    expect{indexer.call()}.to raise_error(ArgumentError)
  end

  it "raises ArgumentError when chances are 0" do
    expect{indexer.call(:chances=>[0,0], :value=>123, :seed=>123)}.to raise_error(ArgumentError)
  end

  it "raises Error when it can't resolve an index" do
    expect{indexer.call(:chances=>[-10, -20], :value=>123, :seed=>123)}.to raise_error(IndexError)
  end

end
