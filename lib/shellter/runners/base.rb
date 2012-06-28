module Shellter
  module Runners
    class Base
      def initialize(options = {})

      end

      def run(command, &block)
        unless defined?(POpen4)
          require 'popen4'
        end
        POpen4.popen4(command, &block)
      end
    end
  end
end