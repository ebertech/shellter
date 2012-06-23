module Shellter
  module ClassMethods
    def run(command, *arguments)
      Command.new(command, *arguments).tap do |command|
        options = arguments.extract_options!
        command.run(options)
      end
    end
    
    def run!(command, *arguments)
      run(command, *arguments).tap do |result|
        raise "Execution failed, with exit code #{result.exit_code}" unless result.success?
      end
    end

    def which(command, paths = nil)
      paths ||= ENV["PATH"].split(File::PATH_SEPARATOR)
      extensions = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']

      paths.each do |path|
        extensions.each do |extension|          
          path_with_extension(path, command, extension).tap do |path_to_command|
            if File.exists?(path_to_command) && File.executable?(path_to_command)
              return path_to_command 
            end
          end
        end
      end

      nil
    end

    private

    def path_with_extension(path, command, extension)
      File.join(File.expand_path(path), "#{command}#{extension}")
    end
  end
end