module JekyllAssetPipeline
  class Cache
    @@cache = {}

    def self.add(key, value)
      @@cache[key] = value
    end

    def self.has_key?(key)
      @@cache.has_key?(key)
    end

    def self.get(key)
      @@cache[key]
    end
  end
end
