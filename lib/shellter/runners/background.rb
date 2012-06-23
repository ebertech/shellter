module Shellter
  module Runners
    class Background < Base
      def run(command, &block)
        ensure_forking!

        # io for child process
        reader, writer = IO.pipe 

        # first fork, create a session leader
        fork do
          reader.close
          Process.setsid 

          # second fork, create a detached child
          # and write its pid to the writer pipe
          result = fork do
            Dir.chdir "/" 
            STDIN.reopen "/dev/null" 
            STDOUT.reopen "/dev/null", "a" 
            STDERR.reopen "/dev/null", "a"

            exec command             
          end
          
          # write the pid of the forked child to the pipe
          writer.puts result
        end

        writer.close
        
        yield StringIO.new, StringIO.new, StringIO.new, reader.gets.strip.to_i
      end
      
      private

      def ensure_forking!
        raise RuntimeError, "Cannot fork on this system!" unless Process.respond_to?(:fork)      
      end
    end
  end
end