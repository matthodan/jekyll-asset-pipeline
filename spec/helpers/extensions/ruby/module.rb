# frozen_string_literal: true

# Allow us to test if a module extends another module/class
#
# For example:
# class SomeClass
#   extend SomeModule
# end
#
# SomeClass.extend?(SomeModule)
# => true
class Module
  def extend?(object)
    is_a?(object)
  end
end
