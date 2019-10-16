# frozen_string_literal: true

require './spec/helper'

# rubocop:disable Metrics/ModuleLength
module JekyllAssetPipeline
  # rubocop:enable Metrics/ModuleLength
  describe Pipeline do
    describe 'class methods' do
      describe '::hash(source, manifest, options = {})' do
        let(:manifest) { "- /_assets/foo.css\n- /_assets/bar.css" }
        let(:expected_hash) do
          Digest::MD5.hexdigest(YAML.safe_load(manifest).map! do |path|
            "#{path}#{File.mtime(File.join(source_path, path)).to_i}"
          end.join.concat(JekyllAssetPipeline::DEFAULTS.to_s))
        end

        subject { JekyllAssetPipeline::Pipeline.hash(source_path, manifest) }

        it 'returns a md5 hash of the manifest contents' do
          _(subject).must_equal(expected_hash)
        end
      end
    end

    describe 'instance methods' do
      # Clean up temp files saved to spec/resources/temp
      after { FileUtils.remove_dir(temp_path, force: true) }

      let(:manifest) { "- /_assets/foo.css\n- /_assets/bar.css" }
      let(:prefix) { 'foobar' }
      let(:type) { '.css' }
      let(:options) { {} }
      let(:pipeline) do
        Pipeline.new(manifest, prefix, source_path, temp_path, type, options)
      end

      describe '#html' do
        subject { pipeline.html }

        before do
          # Mock custom converter
          template = MiniTest::Mock.new
          klass = MiniTest::Mock.new

          YAML.safe_load(manifest).size.times do
            template.expect(:html, 'html')
            klass.expect(:filetype, '.css')
            klass.expect(:new, template, [String, String])
            klass.expect(:nil?, false)
          end

          JekyllAssetPipeline::Template.stub(:subclasses, [klass]) do
            pipeline
          end
        end

        context 'with custom template' do
          it 'outputs template html' do
            _(subject).must_equal('html')
          end
        end
      end

      describe '#assets' do
        subject { pipeline.assets }

        context 'with custom converter' do
          let(:manifest) { '- /_assets/foo.scss' }

          before do
            # Mock custom converter
            converter = MiniTest::Mock.new
            klass = MiniTest::Mock.new

            YAML.safe_load(manifest).size.times do
              converter.expect(:converted, 'converted')
              2.times { klass.expect(:filetype, '.scss') }
              klass.expect(:new, converter, [JekyllAssetPipeline::Asset])
              klass.expect(:nil?, false)
            end

            JekyllAssetPipeline::Converter.stub(:subclasses, [klass]) do
              pipeline
            end
          end

          it 'converts asset content' do
            _(subject.last.content).must_equal('converted')
          end
        end

        context 'bundle => true' do
          let(:options) { { 'bundle' => true } }

          before { pipeline }

          it 'has one asset when multiple files are in manifest' do
            _(YAML.safe_load(manifest).size).must_be :>, 1
            _(subject.size).must_equal(1)
          end

          it 'generates a filename with md5 for the bundled asset' do
            hash = JekyllAssetPipeline::Pipeline
                   .hash(source_path, manifest, options)
            _(subject.last.filename).must_equal("#{prefix}-#{hash}#{type}")
          end

          it 'saves asset to disk at the staging path' do
            asset = subject.last
            staging_path = File.join(source_path, DEFAULTS['staging_path'],
                                     asset.output_path, asset.filename)
            _(File.exist?(staging_path)).must_equal(true)
          end
        end

        context 'bundle => false' do
          let(:options) { { 'bundle' => false } }

          before { pipeline }

          it 'has same number of assets as files in manifest' do
            _(subject.size).must_equal(YAML.safe_load(manifest).size)
          end

          it 'does not change the filenames of the assets' do
            YAML.safe_load(manifest).each do |p|
              _(subject.select do |a|
                a.filename == File.basename(p)
              end.size).must_equal(1)
            end
          end

          it 'saves assets to disk at the staging path' do
            subject.each do |a|
              staging_path = File.join(source_path, DEFAULTS['staging_path'],
                                       a.output_path, a.filename)
              _(File.exist?(staging_path)).must_equal(true)
            end
          end
        end

        context 'compress => true' do
          let(:options) { { 'compress' => true } }

          before do
            # Mock custom compressor
            compressor = MiniTest::Mock.new
            klass = MiniTest::Mock.new

            YAML.safe_load(manifest).size.times do
              compressor.expect(:compressed, 'compressed')
              klass.expect(:filetype, '.css')
              klass.expect(:new, compressor, [String])
              klass.expect(:nil?, false)
            end

            JekyllAssetPipeline::Compressor.stub(:subclasses, [klass]) do
              pipeline
            end
          end

          it 'compresses asset content' do
            subject.each { |a| _(a.content).must_equal('compressed') }
          end
        end

        context 'gzip => true' do
          let(:options) { { 'gzip' => true } }
          let(:manifest) { '- /_assets/foo.css' }

          before do
            Zlib::Deflate.stub(:deflate, 'gzipped') do
              pipeline
            end
          end

          it 'has twice as many assets as files in manifest' do
            _(subject.size).must_equal(YAML.safe_load(manifest).size * 2)
          end

          it 'creates half of assets with filenames ending in .gz' do
            _(subject.select do |asset|
              File.extname(asset.filename) == '.gz'
            end.size).must_equal(subject.size / 2)
          end

          it 'gzips asset content' do
            _(subject.last.content).must_equal('gzipped')
          end
        end
      end
    end
  end
end
