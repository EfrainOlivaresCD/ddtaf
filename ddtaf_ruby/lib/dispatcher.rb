require './lib/handler.rb'

class Dispatcher
  attr_accessor :cmd_keys

  def initialize
    puts "Dispatcher Initialized"
    @cmd_keys = {}
  end

  def addCommand( key )
    @cmd_keys["#{key}"] = "Handler_#{key}" 
  end

  def dump_cmd_keys
    @cmd_keys.each { |key,cmd|
      puts "Key: #{key}\t\tcmd: #{cmd}"
    }
  end
# TODO: this should take key, not cmd as a parameter
  def run( cmd )
    puts "Dispatcher receieved command with key #{cmd.key}"
    if @cmd_keys[cmd.key] != nil
      call = "Handler.#{@cmd_keys[cmd.key]}"
      puts "Dispatcher would be calling #{call}"
      retval = eval("#{call}")
    else
      puts "Dispatcher ERROR: #{cmd.key} was not found in lookup"
    end
  end

end
=begin
cmddis = Dispatcher.new
cmddis.addCommand( "test_key", "test_command")
cmddis.dump_cmd_keys
=end


