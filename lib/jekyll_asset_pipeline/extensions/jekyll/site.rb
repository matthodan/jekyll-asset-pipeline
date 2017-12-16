module Jekyll
  # Contains overrides for the needed Jekyll:Site methods
  # The actual code is in JekyllAssetPipeline::JekyllSiteExtensions
  class Site
    include JekyllAssetPipeline::JekyllSiteExtensions
  end
end
