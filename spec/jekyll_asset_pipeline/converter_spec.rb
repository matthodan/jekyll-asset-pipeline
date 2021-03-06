# frozen_string_literal: true

require './spec/helper'

module JekyllAssetPipeline
  describe Converter do
    specify { _(Converter.extend?(SubclassTracking)).must_equal(true) }

    context 'with default converter class' do
      describe 'class methods' do
        describe '::filetype' do
          specify { _(Converter.filetype).must_be_instance_of(String) }
        end
      end

      describe 'instance methods' do
        let(:asset) { MiniTest::Mock.new }

        before do
          asset.expect(:content, 'foo')
          asset.expect(:filename, 'bar.baz')
          asset.expect(:dirname, '.')
        end

        subject { Converter.new(asset) }

        describe '#new(asset)' do
          specify do
            _(subject.instance_variable_get(:@content)).must_equal('foo')
            _(subject.instance_variable_get(:@type)).must_equal('.baz')
            _(subject.instance_variable_get(:@converted)).must_equal('foo')
          end
        end

        describe '#converted' do
          specify { _(subject.converted).must_equal('foo') }
        end

        describe '#convert' do
          specify { _(subject.convert).must_equal('foo') }
        end
      end
    end

    context 'with custom converter class' do
      before do
        require './spec/resources/source/_plugins/jekyll_asset_pipeline'
      end

      describe 'class methods' do
        describe '::filetype' do
          specify { _(TestConverter.filetype).must_equal('.foo') }
        end
      end

      describe 'instance methods' do
        let(:asset) { MiniTest::Mock.new }

        before do
          asset.expect(:content, 'unconverted')
          asset.expect(:filename, 'some_filename.foo')
          asset.expect(:dirname, '/some/path')
        end

        subject { TestConverter.new(asset) }

        describe '#new(asset)' do
          specify do
            _(
              subject.instance_variable_get(:@content)
            ).must_equal('unconverted')
            _(
              subject.instance_variable_get(:@type)
            ).must_equal('.foo')
            _(
              subject.instance_variable_get(:@converted)
            ).must_equal('converted')
          end
        end

        describe '#converted' do
          specify { _(subject.converted).must_equal('converted') }
        end

        describe '#convert' do
          specify { _(subject.convert).must_equal('converted') }
        end
      end
    end
  end
end
