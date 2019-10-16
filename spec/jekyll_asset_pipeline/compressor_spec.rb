# frozen_string_literal: true

require './spec/helper'

module JekyllAssetPipeline
  describe Compressor do
    specify { _(Compressor.extend?(SubclassTracking)).must_equal(true) }

    context 'with default compressor class' do
      describe 'class methods' do
        describe '::filetype' do
          specify { _(Compressor.filetype).must_be_instance_of(String) }
        end
      end

      describe 'instance methods' do
        subject { Compressor.new('uncompressed') }

        describe '#new(content)' do
          specify do
            _(
              subject.instance_variable_get(:@content)
            ).must_equal('uncompressed')
            _(
              subject.instance_variable_get(:@compressed)
            ).must_equal('uncompressed')
          end
        end

        describe '#compressed' do
          specify { _(subject.compressed).must_equal('uncompressed') }
        end

        describe '#compress' do
          specify { _(subject.compress).must_equal('uncompressed') }
        end
      end
    end

    context 'with default compressor class' do
      before do
        require './spec/resources/source/_plugins/jekyll_asset_pipeline'
      end

      describe 'class methods' do
        describe '::filetype' do
          specify { _(TestCompressor.filetype).must_equal('.foo') }
        end
      end

      describe 'instance methods' do
        subject { TestCompressor.new('uncompressed') }

        describe '#new(content)' do
          specify do
            _(
              subject.instance_variable_get(:@content)
            ).must_equal('uncompressed')
            _(
              subject.instance_variable_get(:@compressed)
            ).must_equal('compressed')
          end
        end

        describe '#compressed' do
          specify { _(subject.compressed).must_equal('compressed') }
        end

        describe '#compress' do
          specify { _(subject.compress).must_equal('compressed') }
        end
      end
    end
  end
end
