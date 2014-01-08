module JAP
  module SubclassTracking
    # Record subclasses of this class (this method is automatically called by ruby)
    def inherited(base)
      subclasses << base
    end

    # Return an array of classes that are subclasses of this object
    def subclasses
      @subclasses ||= []
    end
  end
end
