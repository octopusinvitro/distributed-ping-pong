# frozen_string_literal: true

class UI
  def print_node(node)
    puts("Node #{node.id} at #{node.ip}:#{node.port}")
  end

  def print_message(message)
    from = message.from
    to = message.to

    puts(%(
      Message info:
        from: node at #{from.ip}:#{from.port}
        to:   node at #{to.ip}:#{to.port}
        contents: "#{message.contents}"
    ))
  end

  def print_is_listening(id)
    puts("Node #{id} is now a server too.")
  end

  def print_is_connected(id, address)
    puts("\nNode #{id} established connection with #{address}.")
  end

  def print_connection_error(error, id)
    puts(
      "\nERROR: #{error.message}.\nNode #{id} couldn't connect to cluster.\n"
    )
  end

  def print_listening_error(error, id)
    puts(
      "\nERROR: #{error.message}.\nNode #{id} received this error while listening.\n"
    )
  end

  def request_contents(from)
    "Node #{from.id} is asking to join cluster"
  end

  def response_contents(from)
    "Node #{from.id} has joined cluster"
  end
end
