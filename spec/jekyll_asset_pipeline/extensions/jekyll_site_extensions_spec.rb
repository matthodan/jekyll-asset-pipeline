require './spec/helper'

module JekyllAssetPipeline
  describe JekyllSiteExtensions do
    before do
      # Add dummy data to cache for testing
      Pipeline.cache['foo'] = 'bar'
    end

    describe '#cleanup' do
      subject do
        # Create mock class
        class MockSite
          def cleanup
            'old_return_value'
          end

          def write; end

          include JekyllSiteExtensions
        end

        obj = MockSite.new
        obj.cleanup
      end

      # rubocop:disable LineLength
      it 'clears JekyllAssetPipeline::Cache (when Jekyll::Site#cleanup is called)' do
        # rubocop:enable LineLength
        subject # Setup subject
        Pipeline.cache.key?('foo').must_equal(false)
      end

      it 'returns the same value as the original Jekyll::Site#cleanup method' do
        subject.must_equal('old_return_value')
      end
    end

    describe '#write' do
      subject do
        # Create mock class
        class MockSite
          def cleanup; end

          def write
            'old_write_return_value'
          end

          def config
            {}
          end

          def source
            '/tmp/'
          end

          include JekyllSiteExtensions
        end

        obj = MockSite.new
        obj.write
      end

      it 'returns the same value as the original Jekyll::Site#write method' do
        subject.must_equal('old_write_return_value')
      end

      it 'removes the staged assets via Pipeline.remove_staged_assets' do
        FileUtils.touch('/tmp/.asset_pipeline')
        subject
        File.exist?('/tmp/.asset_pipeline').must_equal(false)
      end
    end
  end
end
