# frozen_string_literal: true

class UI
  def print_node(node)
    puts(
      "Node info: ID = #{node.id}, address = #{node.ip}, " \
      "port = #{node.port}"
    )
  end

  def print_message(message)
    puts(
      "\nMessage info: from = #{message.from.id}, to = #{message.to.id}, " \
      "contents = #{message.contents}"
    )
  end

  def print_exit(id)
    puts("Node #{id}: Quitting. Set server flag to make the node a server")
  end

  def print_is_server(id)
    puts("Will start node #{id} as server.")
  end

  def print_is_connected(id)
    puts("\nNode #{id}: Connected to cluster. Sending message to node.")
  end

  def print_connection_error(error, id)
    puts(
      "\nERROR: #{error.message}.\nNode #{id}: Couldn't connect to cluster.\n"
    )
  end

  def print_listening_error(error, id)
    puts(
      "\nERROR: #{error.message}.\nNode #{id}: Error received while listening.\n"
    )
  end
end
