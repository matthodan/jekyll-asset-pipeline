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
    kind_of?(object)
  end
end
