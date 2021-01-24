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
        msg = decode_msg(command, payload)
        print "\n => receive #{command}. #{msg.to_h}"
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

      def decode_msg(command, payload = nil)
        case command
        when Bitcoin::Message::Version::COMMAND
          Bitcoin::Message::Version.parse_from_payload(payload)
        when Bitcoin::Message::VerAck::COMMAND
          Bitcoin::Message::VerAck.new
        when Bitcoin::Message::GetAddr::COMMAND
          Bitcoin::Message::GetAddr.new
        when Bitcoin::Message::Addr::COMMAND
          Bitcoin::Message::Addr.parse_from_payload(payload)
        when Bitcoin::Message::SendHeaders::COMMAND
          Bitcoin::Message::SendHeaders.new
        when Bitcoin::Message::FeeFilter::COMMAND
          Bitcoin::Message::FeeFilter.parse_from_payload(payload)
        when Bitcoin::Message::Ping::COMMAND
          Bitcoin::Message::Ping.parse_from_payload(payload)
        when Bitcoin::Message::Pong::COMMAND
          Bitcoin::Message::Pong.parse_from_payload(payload)
        when Bitcoin::Message::GetHeaders::COMMAND
          Bitcoin::Message::GetHeaders.parse_from_payload(payload)
        when Bitcoin::Message::Headers::COMMAND
          Bitcoin::Message::Headers.parse_from_payload(payload)
        when Bitcoin::Message::Block::COMMAND
          Bitcoin::Message::Block.parse_from_payload(payload)
        when Bitcoin::Message::Tx::COMMAND
          Bitcoin::Message::Tx.parse_from_payload(payload)
        when Bitcoin::Message::NotFound::COMMAND
          Bitcoin::Message::NotFound.parse_from_payload(payload)
        when Bitcoin::Message::MemPool::COMMAND
          Bitcoin::Message::MemPool.new
        when Bitcoin::Message::Reject::COMMAND
          Bitcoin::Message::Reject.parse_from_payload(payload)
        when Bitcoin::Message::SendCmpct::COMMAND
          Bitcoin::Message::SendCmpct.parse_from_payload(payload)
        when Bitcoin::Message::Inv::COMMAND
          Bitcoin::Message::Inv.parse_from_payload(payload)
        when Bitcoin::Message::MerkleBlock::COMMAND
          Bitcoin::Message::MerkleBlock.parse_from_payload(payload)
        when Bitcoin::Message::CmpctBlock::COMMAND
          Bitcoin::Message::CmpctBlock.parse_from_payload(payload)
        when Bitcoin::Message::GetData::COMMAND
          Bitcoin::Message::GetData.parse_from_payload(payload)
        end
      end

      def unbind
        puts "\n => connection is closed. please stop."
      end

    end

  end
end