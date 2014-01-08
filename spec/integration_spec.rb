require './spec/helper'

describe JAPR do
  # Sensible defaults
  let(:manifest) { "- /_assets/foo.css\n- /_assets/bar.css" }
  let(:prefix) { 'global' }
  let(:config) { {} }
  let(:tag_name) { 'css_asset_tag' }
  let(:extension) { '.css' }

  after do
    Pipeline.clear_cache
    clear_temp_path
  end

  it "saves assets to staging path" do
    $stdout.stub(:puts, nil) do
      config['output_path'] = 'foobar_assets'
      pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                      tag_name, extension, config)
      pipeline.assets.each do |asset|
        file_path = File.join(source_path, DEFAULTS['staging_path'], config['output_path'], asset.filename)
        File.open(file_path) do |file|
          file.read.must_equal(asset.content)
        end
      end
    end
  end

  it "outputs processing and saved file status messages" do
    hash = Pipeline.hash(source_path, manifest, config)
    filename = "#{prefix}-#{hash}#{extension}"
    path = File.join(temp_path, DEFAULTS['output_path'])

    expected = "Asset Pipeline: Processing '#{tag_name}' manifest '#{prefix}'\n" +
               "Asset Pipeline: Saved '#{filename}' to '#{path}'\n"

    proc do
      pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                      tag_name, extension, config)
    end.must_output(expected)
  end

  it "uses cached pipeline if manifest has been previously processed" do
    $stdout.stub(:puts, nil) do
      pipeline1, cached1 = Pipeline.run(manifest, prefix, source_path, temp_path,
                                      tag_name, extension, config)
      cached1.must_equal(false)

      pipeline2, cached2 = Pipeline.run(manifest, prefix, source_path, temp_path,
                                      tag_name, extension, config)
      cached2.must_equal(true)
      pipeline2.must_equal(pipeline1)
    end
  end

  describe "templating" do
    it "overrides default if custom css template is defined" do
      # Define test template
      module JAPR
        class NewCssTagTemplate < Template
          def self.filetype
            '.css'
          end

          def html
            "foobar_template"
          end
        end
      end

      $stdout.stub(:puts, nil) do
        pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                        tag_name, '.css', config)
        pipeline.html.must_equal('foobar_template')
      end

      # Clean up test template
      Template.subclasses.delete(NewCssTagTemplate)
      Object::JAPR.send(:remove_const, :NewCssTagTemplate)
    end

    it "overrides default if custom js template is defined" do
      # Define test template
      module JAPR
        class NewJsTagTemplate < Template
          def self.filetype
            '.js'
          end

          def html
            "foobar_template"
          end
        end
      end

      $stdout.stub(:puts, nil) do
        pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                        tag_name, '.js', config)
        pipeline.html.must_equal('foobar_template')
      end

      # Clean up test template
      Template.subclasses.delete(NewJsTagTemplate)
      Object::JAPR.send(:remove_const, :NewJsTagTemplate)
    end
  end

  describe "pipeline#html" do
    it "returns html link tag if css" do
      $stdout.stub(:puts, nil) do
        pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                        tag_name, '.css', config)
        pipeline.html.must_match(/link/i)
      end
    end

    it "returns html script tag if js" do
      $stdout.stub(:puts, nil) do
        pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                        tag_name, '.js', config)
        pipeline.html.must_match(/script/i)
      end
    end

    it "links to display_path if option is set" do
      $stdout.stub(:puts, nil) do
        config['display_path'] = 'foo/bar/baz'
        pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                        tag_name, '.js', config)
        pipeline.html.must_match(/foo\/bar\/baz/)
      end
    end
  end

  context "bundle => true" do
    before do
      config['bundle'] = true
    end

    it "bundles assets into one file when bundle => true" do
      $stdout.stub(:puts, nil) do
        pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                        tag_name, extension, config)
        pipeline.assets.size.must_equal(1)
      end
    end

    it "saves bundled file with filename starting with prefix" do
      $stdout.stub(:puts, nil) do
        pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                        tag_name, extension, config)
        pipeline.assets.each do |asset|
          asset.filename[0, prefix.length].must_equal(prefix)
        end
      end
    end
  end

  context "bundle => false" do
    before do
      config['bundle'] = false
    end

    it "saves each file in manifest" do
      $stdout.stub(:puts, nil) do
        pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                        tag_name, extension, config)
        file_paths = YAML::load(manifest)
        pipeline.assets.size.must_equal(file_paths.size)
        files = file_paths.map { |f| File.basename(f) }
        pipeline.assets.each do |asset|
          files.must_include(asset.filename)
        end
      end
    end
  end

  describe "asset conversion" do
    it "converts asset with converter based on file extension" do
      # Define test converter
      module JAPR
        class BazConverter < Converter
          def self.filetype
            '.baz'
          end

          def convert
            return 'converted'
          end
        end
      end

      manifest = "- /_assets/unconverted.css.baz"
      $stdout.stub(:puts, nil) do
        pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                        tag_name, extension, config)
        pipeline.assets.each do |asset|
          asset.content.must_equal('converted')
        end
      end

      # Clean up test converters
      Converter.subclasses.delete(BazConverter)
      Object::JAPR.send(:remove_const, :BazConverter)
    end

    it "ensures that converted asset is saved with expected extension" do
      # Define test converter
      module JAPR
        class BazConverter < Converter
          def self.filetype
            '.baz'
          end

          def convert
            return 'converted'
          end
        end
      end

      manifest = "- /_assets/unconverted.baz"
      $stdout.stub(:puts, nil) do
        pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                        tag_name, extension, config)
        pipeline.assets.each do |asset|
          asset.content.must_equal('converted')
          File.extname(asset.filename).must_equal('.css')
        end
      end

      # Clean up test converters
      Converter.subclasses.delete(BazConverter)
      Object::JAPR.send(:remove_const, :BazConverter)
    end

    context "when using multiple converters" do
      before do
        # Define test converters
        module JAPR
          class BarConverter < Converter
            def self.filetype
              '.bar'
            end

            def convert
              return 'converted to bar'
            end
          end

          class BazConverter < Converter
            def self.filetype
              '.baz'
            end

            def convert
              return 'converted to baz'
            end
          end
        end
      end

      after do
        # Clean up test converters
        Converter.subclasses.delete(BarConverter)
        Converter.subclasses.delete(BazConverter)
        Object::JAPR.send(:remove_const, :BarConverter)
        Object::JAPR.send(:remove_const, :BazConverter)
      end

      it "converts asset multiple times if needed in order based on extension" do
        $stdout.stub(:puts, nil) do
          manifest = "- /_assets/unconverted.css.baz.bar"
          pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                          tag_name, extension, config)
          pipeline.assets.each do |asset|
            asset.content.must_equal('converted to baz')
          end

          manifest = "- /_assets/unconverted.css.bar.baz"
          pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                          tag_name, extension, config)
          pipeline.assets.each do |asset|
            asset.content.must_equal('converted to bar')
          end
        end
      end
    end
  end

  describe "asset compression" do
    it "compresses assets with compressor based on file extension" do
      # Define test compressor
      module JAPR
        class CssCompressor < Compressor
          def self.filetype
            '.css'
          end

          def compress
            return 'compressed'
          end
        end
      end

      $stdout.stub(:puts, nil) do
        manifest = "- /_assets/uncompressed.css"
        pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                        tag_name, extension, config)
        pipeline.assets.each do |asset|
          asset.content.must_equal('compressed')
        end
      end

      # Clean up test compressor
      Compressor.subclasses.delete(CssCompressor)
      Object::JAPR.send(:remove_const, :CssCompressor)
    end
  end

  describe "error handling" do
    it "outputs error message if fails to read manifest" do
      manifest = "invalid_manifest"
      proc do
        proc do
          pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
            tag_name, extension, config)
        end.must_raise(NoMethodError)
      end.must_output(/failed/i)
    end

    it "outputs error message if failure to convert asset" do
      # Define test converter
      module JAPR
        class BazConverter < Converter
          def self.filetype
            '.baz'
          end

          def convert
            raise Exception
          end
        end
      end

      manifest = "- /_assets/unconverted.baz"
      proc do
        proc do
          pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                          tag_name, extension, config)
        end.must_raise(Exception)
      end.must_output(/failed/i)

      # Clean up test converters
      Converter.subclasses.delete(BazConverter)
      Object::JAPR.send(:remove_const, :BazConverter)
    end

    it "outputs error message if failure to compress asset" do
      # Define test compressor
      module JAPR
        class CssCompressor < Compressor
          def self.filetype
            '.css'
          end

          def compress
            raise Exception
          end
        end
      end

      manifest = "- /_assets/uncompressed.css"
      proc do
        proc do
          pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                          tag_name, extension, config)
        end.must_raise(Exception)
      end.must_output(/failed/i)

      # Clean up test compressor
      Compressor.subclasses.delete(CssCompressor)
      Object::JAPR.send(:remove_const, :CssCompressor)
    end

    it "stops processing pipeline if previously generated error" do
      # Define test converter
      module JAPR
        class BazConverter < Converter
          def self.filetype
            '.baz'
          end

          def convert
            raise Exception
          end
        end
      end

      manifest = "- /_assets/unconverted.baz"
      proc do
        proc do
          pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                          tag_name, extension, config)
        end.must_raise(Exception)
      end.must_output(/failed/i)

      proc do
        pipeline, cached = Pipeline.run(manifest, prefix, source_path, temp_path,
                                        tag_name, extension, config)
      end.must_output(nil)

      # Clean up test converters
      Converter.subclasses.delete(BazConverter)
      Object::JAPR.send(:remove_const, :BazConverter)
    end

  end
end
