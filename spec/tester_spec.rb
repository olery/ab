require 'spec_helper'
require 'securerandom'

describe Ab::Tester do

  it "should initialize with no options" do
    expect{Tester.new}.to_not raise_error
  end

  it "should initialize with options" do
    expect{Tester.new(:options=>[1,2,3], :chances=>"1/2/2", :input=>50)}.to_not raise_error
  end

  it "should remember the options" do
    Tester.new(:options=>[1,2,3]).options.should eql([1,2,3])
  end

  it "should remember the chances" do
    Tester.new(:chances=>"10/10/10").chances.should_not be_nil
  end

  it "should remember the input" do
    Tester.new(:input=>10).input.should eql(10)
  end

  it "should check if the amount of options equals the amount of chances" do
    expect{Tester.new(:options=>[1,2,3], :chances=>"10/30").call}.to raise_error(ArgumentError)
  end

  it "should be able to set it's own indexer" do
    Tester.new(:options=>[1,2,3],
               :chances=>"0/0/1",
               :indexer=>Proc.new{|a,b| 1}).call(1235).should eql(2)
  end

  it "uses a sane default indexer" do
    Tester.new(:chances=>"1/0/0", :options=>[1,2,3]).call(1235).should eql(1)
    Tester.new(:chances=>"0/1/0", :options=>[1,2,3]).call(1235).should eql(2)
    Tester.new(:chances=>"0/0/1", :options=>[1,2,3]).call(1235).should eql(3)
  end
  
  it "returns same result for same input" do
    100.times do
      Tester.new(:name => "Test", :options=>[1,2,3], :chances => "1/1/1").call(54321).should eql(3)
    end
  end

  it "should take a block and provide the result to the block" do
    expect do |b|
      Tester.new(:chances=>"1/0/0", :options=>[1,2,3])\
        .call(1235, &b)
    end.to yield_with_args(1)
  end
  
  context 'distribution of results' do
    it 'distributes almost equally in 1000 iterations 50/50 chance' do
      result = []
      1000.times do
        random = SecureRandom.random_number(1000000000)
        result << Tester.new(:name => "Test", :chances => "1/1").call(random)
      end
    
      result.count(true).should be_within(50).of(500)
    end
    
    it 'distributes almost equally in 1000 iterations 33/33/33 chance' do
      result = []
      1000.times do
        random = SecureRandom.random_number(1000000000)
        result << Tester.new(:name => "Test", :options=>[1,2,3], :chances => "1/1/1").call(random)
      end
      
      result.count(1).should be_within(50).of(333)
    end
  end
end
