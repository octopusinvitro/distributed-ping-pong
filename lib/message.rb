# frozen_string_literal: true

require 'json'

class Message
  attr_reader :from, :to, :contents

  def initialize(from, to, contents)
    @from = from
    @to = to
    @contents = contents
  end

  def to_json(_ = nil)
    {
      join_cluster: {
        source: from.to_h,
        destination: to.to_h,
        contents:
      }
    }.to_json
  end
end
