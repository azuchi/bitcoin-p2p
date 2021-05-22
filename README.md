# Bitcoin P2P message REPL tool

`bitcoin-p2p` is an irb-based tool for interactively exchanging P2P messages with Bitcoin nodes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bitcoin-p2p'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install bitcoin-p2p

## Usage

Start `bitcoin-p2p` by specifying the address and network of the node to connect to.

    $ bitcoin-p2p -h localhost -n signet
    > connected! You can send version message.

Once connected, you can use the [bitcoinrb message class](https://github.com/chaintope/bitcoinrb/wiki/P2P-Message) 
to construct a P2P message and use the `send_message` method to send that message to the other party.
For example, the handshake can be done as follows:

    > ver = Bitcoin::Message::Vresion.new
    => #<Bitcoin::Message::Version:0x00005590317410f0 @version=70013, @services=8, @timestamp=1611462693, @local_addr=#<Bitcoin::Message::NetworkAddr:0x0000559031738ae0 @time=1611462693, @ip_addr=#<IPAddr: IPv4:127.0.0.1/255.255.255.255>, @port=3...
    > send_message(ver)
    => send message data: 0a03cf4076657273696f6e00000000006700000093cb71427d110100080000000000000025f80c6000000000080000000000000000000000000000000000ffff7f00000195bd080000000000000000000000000000000000ffff7f00000195bd519f0f6807576b1c112f626974636f696e72623a302e362e302f0000000000
    ...
    =>  receive version. payload: {"version"=>70016, "services"=>1097, "timestamp"=>1611462696, "local_addr"=>{"time"=>nil, "ip_addr"=>#<IPAddr: IPv6:0000:0000:0000:0000:0000:0000:0000:0000/ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff>, "port"=>0, "services"=>0}, "remote_addr"=>{"time"=>nil, "ip_addr"=>#<IPAddr: IPv6:0000:0000:0000:0000:0000:0000:0000:0000/ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff>, "port"=>0, "services"=>1033}, "nonce"=>5555482496462444166, "user_agent"=>"/Satoshi:0.21.0/", "start_height"=>21843, "relay"=>true}
    > ack = Bitcoin::Message::VerAck.new
    => #<Bitcoin::Message::VerAck:0x00005590316342c0> 
    > send_message(ack)
    => send message data: 0a03cf4076657261636b000000000000000000005df6e0e2

Note, You will be able to send other messages, but if the message you send does not comply with the specifications or 
violates the policy of the other party, you will be disconnected. 
In this case, a message will be displayed on the console saying `=> connection is closed. Please stop.`, so end with `stop`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bitcoin-p2p. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/bitcoin-p2p/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bitcoin::P2p project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/bitcoin-p2p/blob/master/CODE_OF_CONDUCT.md).
