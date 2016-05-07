# frozen_string_literal: true

class PingPong
  def initialize(factory, connection, ui)
    @factory = factory
    @connection = connection
    @ui = ui
  end

  def play
    server = factory.server
    client = factory.client
    ui.print_node(client)

    connection.connect_to_cluster(client, server)

    server = client
    connection.listen_to_cluster(server)
  end

  private

  attr_reader :factory, :connection, :ui
end
