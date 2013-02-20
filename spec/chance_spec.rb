require 'spec_helper'

describe Olery::AB::Chance do
  it "should split a string into a an array of integers" do
    Chance.split_chance("10/20/30").should eql([10,20,30])
  end

  it "should not accept minus chances" do
    expect{Chance.new("-1/0/0")}.to raise_error(ArgumentError)
  end

  context "normalizing" do
    it "should normalize tens" do
      Chance.normalize([10,15,25]).should eql([20,30,50])
    end

    it "should normalize thousands" do
      Chance.normalize([1000,1500,2500]).should eql([20,30,50])
    end

    it "should normalize decimals" do
      Chance.normalize([0.1,0.15,0.25]).should eql([20,30,50])
    end

    it "should cope with zero's" do
      Chance.normalize([0,0,1]).should eql([0,0,100])
    end

  end
end

