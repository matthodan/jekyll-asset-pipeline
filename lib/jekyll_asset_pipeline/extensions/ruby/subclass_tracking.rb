# frozen_string_literal: true

module JekyllAssetPipeline
  # Allows classes that extend this to return an array of their subclasses
  module SubclassTracking
    # Record subclasses of this class (this method is automatically called by
    # ruby)
    def inherited(base)
      subclasses << base
    end

    # Return an array of classes that are subclasses of this object
    def subclasses
      @subclasses ||= []
    end
  end
end
