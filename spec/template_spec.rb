require './spec/helper'

describe Template do
  describe "class methods" do
    subject { Template }

    describe "::filetype" do
      it "returns a string" do
        subject.filetype.must_be_instance_of String
      end
    end

    describe "::priority" do
      it "returns an fixnum" do
        subject.priority.must_be_instance_of Fixnum
      end
    end
  end

  describe "instance methods" do
    let(:template) { Template.new('foo', 'bar') }

    subject { template }

    describe "#new(path, filename)" do
      it "sets @path" do
        subject.instance_variable_get(:@path).wont_be_nil
      end

      it "sets @filename" do
        subject.instance_variable_get(:@filename).wont_be_nil
      end
    end

    describe "#html" do
      it "returns a string" do
        subject.html.must_be_instance_of String
      end
    end
  end
end
