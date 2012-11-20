module JekyllAssetPipeline
  class Extendable
    # Record subclasses of this class (this method is automatically called by ruby)
    def self.inherited(base)
      subclasses << base
    end

    # Return an array of classes that are subclasses of this object
    def self.subclasses
      @subclasses ||= []
    end
  end
end
