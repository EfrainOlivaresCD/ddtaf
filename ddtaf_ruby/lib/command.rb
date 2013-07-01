
class Command
  attr_accessor :key, :params

  def initialize( key, params={} )
    puts "Command initialized with key: #{key}"
    @key = key
  end

end
