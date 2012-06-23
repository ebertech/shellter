# Shellter

Do YOU like to fork(2)? Do YOU like cocaine(https://github.com/thoughtbot/cocaine)? Of course, we all do. The problem is that I needed a ever-rounder wheel than what I've found. The Escape gem was a nice place to find shell escaping... but it didn't do interpolation or actually execute anything. The Cocaine gem was a nice place to find interpolation, but its escaping was a bit too simple for my tastes and it didn't manage STDERR, STDOUT in a way that let me inspect them easily afterward. I've also always wanted to be able to start a process in the background without having to worry about what I need to close and open and how many times I need to fork (but if you want to know everything about it, I'd suggest you read http://workingwithunixprocesses.com/). 

So in the grand spirit of the GitHubs here's a gem that does all of the above. The idea is that your result is going to be more than just an exit status. Here's what you'll get:

* The fully interpolated command that was last run
* The exit status
* The entire STDERR and STDOUT
* The PID

Yes, of course I'm using POpen4 under the covers. The interpolation is taken from Cocaine and modified to use Escape to do the shell escaping. 

The point is that it's supposed to be an easy-to-remember, easy-to-use library that takes care of everything else. 

## Backgrounding

Sure there's a ton of gems that let you manage background processes and the like. Daemons (http://daemons.rubyforge.org/) is an obvious example. Sometimes, though, you just want to "fire and forget." Shellter provides a SIMPLE way of demonizing a command whilst returning you its PID so that you can do with it what you like.  

## Installation

Add this line to your application's Gemfile:

    gem 'shellter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shellter

## Usage

The most basic usage is like this:

	result = Shellter.run("ls")
	
That's it. This returns a Shellter::Command which has the following variables:

	result.pid
	result.stdout
	result.stderr
	result.last_command # the fully-interpolated command that was run
	
Want to pass arguments that you KNOW are safe? 

	Shellter.run("ls", "-l", "*.rb") # ls -l *.rb
	
Want to pass arguments that might have spaces in them? 

	myvar = "'\"\'some ../../weird#""'`#{}` filena_?me"
	Shellter.run("ls", "-l", ":weird", :weird => myvar) # ls -l \''"'\''some ../../weird#'\''`` filena_?me'
	
	hateful = "'$(rm -rf *.foo)"
	Shellter.run("ls", "-l", ":weird", :weird => hateful) # ls -l \''$(rm -rf *.foo)'

Want to raise an exception if the command doesn't return 0?
	
	Shellter.run!("ls", "*.missing") # RuntimeError: Execution failed, with exit code 256
	
Want to find out if the command ran ok?

	Shellter.run("ls", "*.missing").success? # false
	
Want to provide a list of exit codes that you're ok with? 

	Shellter.run!("ls", "*.missing", :expected_outcodes => [0, 256]).success? # true
	
Want to start that command in the background? 

	Shellter.run("ls", :background => true)
	
*NOTE:* When backgrounded, the command `fork`s twice in order to fully detach from the session. This, of course, means that the stderr, and stdout will be empty. The pid, however, will be of the last `fork` before `exec`-ing.

*NOTE:* Before backgrounding we check to see if `fork` is actually available and throw an Exception if it isn't. 

Also included is an implementation of the UNIX `which` command:

	Shellter.which("ls") # /bin/ls

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
