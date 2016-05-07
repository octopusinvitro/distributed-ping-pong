# frozen_string_literal: true

class Node
  attr_reader :id, :address

  def initialize(id, address)
    @id = id
    @address = address
  end

  def ip
    address_parts.first
  end

  def port
    address_parts.last
  end

  def to_h
    { id:, ip:, port: }
  end

  private

  def address_parts
    @address_parts ||= address.split(':')
  end
end
