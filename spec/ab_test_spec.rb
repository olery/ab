require 'spec_helper'
require 'ab/view_helpers.rb'

describe "Helper Method" do
  class View
    include Ab::ViewHelpers
  end

  let(:view){ View.new}

  it "should do nothing on empty calls" do
    expect{view.ab}.to_not raise_error
  end

  it "should take multiple options" do
    expect{view.ab(:options=>[1,2,3], :chance=>"1/2/2", :input=>50)}.to_not raise_error
  end

end

