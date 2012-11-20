module JekyllAssetPipeline
  class JavaScriptAssetTag < Liquid::Block
    def render(context)
      # Get YAML manifest from Liquid block
      manifest = @nodelist.first
      prefix = @markup.lstrip.rstrip

      # Compile bundle based on manifest
      site = context.registers[:site]
      bundle = JekyllAssetPipeline::Bundler.new(site, prefix, manifest, '.js')

      # Return HTML tag linked to bundle
      return bundle.html_tag
    end
  end

  # Register JavaScriptAssetTag tag with Liquid
  Liquid::Template.register_tag('javascript_asset_tag', JekyllAssetPipeline::JavaScriptAssetTag)
end
