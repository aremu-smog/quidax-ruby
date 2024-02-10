# frozen_string_literal: true

# Base for errors thrown by the quidax server
class QuidaxServerError < StandardError
  attr_reader :response

  def initialize(response)
    super(response)
    @response = response
  end
end
