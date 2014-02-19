require 'rubygems'
require 'bunny'

conn = Bunny.new
conn.start

ch = conn.create_channel #opens a new channel to multiplex a TCP connection
q  = ch.queue("bunny.examples.hello_world", auto_delete: true) #create a queue with this name. remove queue when there are no more processes consuming messages
#instantiates an exchange. which receives messages sent by a producer. exchange routes to queues according to bindings. default exchange has implied bindings to all queues
x  = ch.default_exchange

q.subscribe do |delivery_info, metadata, payload|
	puts "Received #{payload}"
end

x.publish("Hello!", routing_key: q.name)

sleep 1.0
conn.close