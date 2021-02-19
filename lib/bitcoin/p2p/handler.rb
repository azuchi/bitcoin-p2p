module Bitcoin
  module P2P

    module Handler

      def post_init
        puts "> connected! You can send version message."
      end

      def receive_data(data)
        begin
          parse(data)
        rescue Bitcoin::Message::Error => e
          puts "invalid header magic. #{e.message}"
        end
      end

      def parse(message)
        @message ||= ''
        @message += message
        command, payload, rest = parse_header
        return unless command
        msg = Bitcoin::Message.decode(command, payload.bth)
        puts
        puts " => receive #{command}. #{msg.to_h}"
        @message = ""
        parse(rest) if rest && rest.bytesize > 0
      end

      def parse_header
        head_magic = Bitcoin.chain_params.magic_head
        return if @message.nil? || @message.size < Bitcoin::MESSAGE_HEADER_SIZE

        magic, command, length, checksum = @message.unpack('a4A12Va4')
        raise Bitcoin::Message::Error, "invalid header magic. #{magic.bth}" unless magic.bth == head_magic

        payload = @message[Bitcoin::MESSAGE_HEADER_SIZE...(Bitcoin::MESSAGE_HEADER_SIZE + length)]
        return if payload.size < length
        raise Bitcoin::Message::Error, "header checksum mismatch. #{checksum.bth}" unless Bitcoin.double_sha256(payload)[0...4] == checksum

        rest = @message[(Bitcoin::MESSAGE_HEADER_SIZE + length)..-1]
        [command, payload, rest]
      end

      def unbind
        puts "\n => connection is closed. please stop."
      end

    end

  end
end