require 'spec_helper'

describe Olery::AB::IntIndexer do
  let(:indexer){ Olery::AB::IntIndexer }


  it "should process a bunch of options" do
    options = [
      {:chances=>[100,0], :value=>123, :result=>0},
    ]

    options.each do |option|
      indexer.call(option).should eql(option[:result])
    end
  end

end
