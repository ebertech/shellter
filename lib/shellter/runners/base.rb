require 'popen4'

module Shellter
  module Runners
    class Base
      def initialize(options = {})
        
      end
      
      def run(command, &block)
        POpen4.popen4(command, &block)
      end
    end
  end
end