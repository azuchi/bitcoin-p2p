module Bitcoin
  module P2P

    class CLI

      attr_accessor :host
      attr_accessor :network

      def parse
        op = OptionParser.new do |opts|
          opts.banner = "Usage: bitcoin-p2p -h <host> -n <network>"

          opts.on("-h host", "--host host", "IP address of the connection destination.") do |v|
            self.host = v
          end

          opts.on("-n network", "--network network", "Network to connect to.(mainnet or testnet or signet)") do |v|
            self.network = v.to_sym
          end

          [host, network]
        end

        begin
          puts op.parse(ARGV)
          unless host
            puts "Specify the host to connect to via -h option."
            exit(1)
          end
          unless %w(mainnet testnet signet).include?(network.to_s)
            puts "The network option must be either mainnet, testnet, or signet."
            exit(1)
          end
        rescue OptionParser::InvalidOption => e
          puts e.message
        end

        4.times {ARGV.shift}
      end

    end
  end
end