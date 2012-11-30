require './spec/helper'

describe Converter do
  describe "class methods" do
    subject { Converter }

    describe "::filetype" do
      it "returns a string" do
        subject.filetype.must_be_instance_of String
      end
    end
  end

  describe "instance methods" do
    let(:file) { MiniTest::Mock.new }
    let(:converter) do
      File.stub :extname, '.foobar' do
        Converter.new(file)
      end
    end

    before do
      file.expect :read, 'foobar'
      file.expect :must_equal, true, [file]
    end

    subject { converter }

    describe "#new(file)" do
      it "sets @file to the file" do
        subject.instance_variable_defined?(:@file).must_equal true
        subject.instance_variable_get(:@file).must_equal file
      end

      it "sets @content to the contents of the file" do
        subject.instance_variable_defined?(:@content).must_equal true
        subject.instance_variable_get(:@content).must_equal 'foobar'
      end

      it "sets @type to the extension of the file" do
        subject.instance_variable_defined?(:@type).must_equal true
        subject.instance_variable_get(:@type).must_equal '.foobar'
      end

      it "sets @converted to the #convert response" do
        subject.instance_variable_defined?(:@converted).must_equal true
        subject.instance_variable_get(:@converted).must_equal subject.convert
      end
    end

    describe "#convert" do
      it "returns @content" do
        subject.convert.must_equal subject.instance_variable_get(:@content)
      end
    end

    describe "#converted" do
      it "returns @converted" do
        subject.converted.must_equal subject.instance_variable_get(:@converted)
      end
    end
  end
end
