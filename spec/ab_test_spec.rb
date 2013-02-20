require 'spec_helper'

describe "Helper Method" do
  class View
    include Olery::AB::Test
  end

  let(:view){ View.new}

  it "should do nothing on empty calls" do
    expect{view.ab_test}.to_not raise_error
  end

  it "should take multiple options" do
    expect{view.ab_test(:options=>[1,2,3], :chance=>"1/2/2", :input=>50)}.to_not raise_error
  end

end

