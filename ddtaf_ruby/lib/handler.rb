module Handler
=begin
  class Handler
    attr_accessor :cmd
    def initialize( cmd )
      @cmd = cmd
    end
  
    def execute
      puts "Handler Doing Something"
    end
  end
  
  class Handler_test < Handler
    def execute
      puts "TEST HANDLER doing something"
    end
  end
=end 
  def Handler.Handler_test1
    puts "HANDLER action being handled by function"
  end

# end module
end
