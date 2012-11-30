require './spec/helper'

describe Extendable do
  describe "::subclasses" do
    before do
      class FooBar < Extendable; end
    end

    it "returns an array" do
      Extendable.subclasses.must_be_instance_of Array
    end

    it "returned array contains all subclasses of Extendable" do
      Extendable.subclasses.must_include FooBar
    end
  end
end
