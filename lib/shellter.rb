require 'escape'

require 'shellter/core_ext'

module Shellter
  autoload :ClassMethods, "shellter/class_methods"
  autoload :Command, "shellter/command"
  autoload :VERSION, "shellter/version"
  
  module Runners
    autoload :Background, "shellter/runners/background"
    autoload :Base, "shellter/runners/base"
    autoload :Windows, "shellter/runners/windows"
  end
  
  extend ClassMethods
end
