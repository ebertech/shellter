module Shellter
  class Command

    attr_reader :pid
    attr_reader :stdout
    attr_reader :stderr
    attr_reader :last_command

    def initialize(command, *arguments)
      options = arguments.extract_options!

      @expected_outcodes = options.delete(:expected_outcodes)
      @expected_outcodes ||= [0]

      @command = command
      @arguments = arguments 
      
      @stdout = StringIO.new     
      @stderr = StringIO.new     
    end

    def run(options = {})
      with_env(options) do
        with_runner(options) do |runner|
          with_interpolated_command(options) do |command|
            @status = runner.run(command) do |stdout, stderr, stdin, pid|
              stdin.close
              @stdout.write(stdout.read)
              @stderr.write(stderr.read)
              @pid = pid
            end
            @stderr.rewind
            @stdout.rewind
          end
        end
      end
    end  

    def exit_code
      @status.to_i
    end

    def success?
      @expected_outcodes.include?(exit_code)
    end

    private
    
    def interpolate(pattern, vars)
      # interpolates :variables and :{variables}
      pattern.gsub(%r#:(?:\w+|\{\w+\})#) do |match|
        key = match[1..-1]
        key = key[1..-2] if key[0,1] == '{'
        if invalid_variables.include?(key)
          raise InterpolationError,
            "Interpolation of #{key} isn't allowed."
        end
        interpolation(vars, key) || match
      end
    end

    def invalid_variables
      %w(expected_outcodes swallow_stderr logger)
    end

    def interpolation(vars, key)
      if vars.key?(key.to_sym)
        Escape.shell_single_word(vars[key.to_sym])
      end
    end

    def with_env(options = {}, &block)
      begin
        saved_env = ENV.to_hash
        # Bundler.with_clean_env(&block)
        # command = %Q{. #{vars_file_path} && #{script}}
        # ENV.update(self.class.environment)
        yield
      ensure
        ENV.update(saved_env)
      end
    end

    def with_interpolated_command(options, &block)
      [].tap do |command_line|
        command_line << Escape.shell_single_word(@command)
        command_line += interpolated_arguments(options)
        
        command_line.join(" ").tap do |command|
          @last_command = command        
          yield command
        end
      end
    end
    
    def interpolated_arguments(vars)      
      @arguments.map do |argument|
        interpolate(argument, vars)
      end
    end

    def with_runner(options = {}, &block)
      if options[:background]
        yield Runners::Background.new(options)
      elsif windows?
        yield Runners::Windows.new(options)
      else
        yield Runners::Base.new(options)
      end
    end

    def windows?
      !!(RbConfig::CONFIG['host_os'] =~ /mswin|mingw/)      
    end
  end
end