module JekyllAssetPipeline
  class CssAssetTag < Liquid::Block
    def render(context)
      # Get YAML manifest from Liquid block
      manifest = @nodelist.first
      prefix = @markup.lstrip.rstrip

      # Compile bundle based on manifest
      site = context.registers[:site]
      bundle = JekyllAssetPipeline::Bundler.new(site, prefix, manifest, '.css')

      # Return HTML tag linked to bundle
      return bundle.html_tag
    end
  end

  # Register CssAssetTag tag with Liquid
  Liquid::Template.register_tag('css_asset_tag', JekyllAssetPipeline::CssAssetTag)
end
