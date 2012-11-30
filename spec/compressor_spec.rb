require './spec/helper'

describe Compressor do
  describe "class methods" do
    subject { Compressor }

    describe "::filetype" do
      it "returns a string" do
        subject.filetype.must_be_instance_of String
      end
    end
  end

  describe "instance methods" do
    let(:content) { 'foobar' }
    let(:compressor) { Compressor.new(content) }

    subject { compressor }

    describe "#new(content)" do
      it "sets @content to the content" do
        subject.instance_variable_defined?(:@content).must_equal true
        subject.instance_variable_get(:@content).must_equal 'foobar'
      end

      it "sets @compressed to the #compress response" do
        subject.instance_variable_defined?(:@compressed).must_equal true
        subject.instance_variable_get(:@compressed).must_equal subject.compress
      end
    end

    describe "#compress" do
      it "returns @content" do
        subject.compress.must_equal subject.instance_variable_get(:@content)
      end
    end

    describe "#compressed" do
      it "returns @compressed" do
        subject.compressed.must_equal subject.instance_variable_get(:@compressed)
      end
    end
  end
end
