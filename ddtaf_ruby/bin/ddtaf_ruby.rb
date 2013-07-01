#!/usr/bin/env ruby

require './lib/dispatcher'
require './lib/chain'

dispatcher = Dispatcher::new
dispatcher.addCommand( "test1" )

chain_obj = Chain::new
chain = chain_obj.getChain
puts "MAIN chain returned is #{chain.length} units long"

chain.each { |cmd|

  dispatcher.run(cmd)

}

