require 'popen3'
module Shellter
  module Runners
    class Windows < Base
      def run(command, &block)
        exit_status = nil
        Open3.popen3(File.basename(command)) do |stdin, stdout, stderr, wait_thread|
          yield stdout, stderr, stdin, wait_thread.pid
          exit_status = wait_thread.value
        end
        exit_status
      end    
    end
  end
end