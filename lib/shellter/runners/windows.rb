module Shellter
  module Runners
    class Windows < Base
      def run(command, mode = "b", &block)
        POpen4.popen4(command, mode, &block)
      end    
    end
  end
end