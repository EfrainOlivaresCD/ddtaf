require './lib/command'


class Chain
  attr_accessor :chain
  
  def initialize
    @chain = []
  end

  def getChain
    @chain << Command.new("test1")
    return @chain
  end

end
