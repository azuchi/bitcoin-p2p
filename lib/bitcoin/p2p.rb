require "bitcoin/p2p/version"

module Bitcoin
  module P2P
    class Error < StandardError; end

    autoload :Handler, 'bitcoin/p2p/handler'
    autoload :CLI, 'bitcoin/p2p/cli'

  end
end
