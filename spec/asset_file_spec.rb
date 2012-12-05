require './spec/helper'

describe AssetFile do
  describe "instance methods" do
    describe "#write(dest)" do
      subject { AssetFile.new(nil, nil, nil, nil).write('foobar') }

      it "returns true" do
        subject.must_equal true
      end
    end
  end
end
