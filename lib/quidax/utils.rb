# frozen_string_literal: true

require_relative "error"

# Base Util
module Utils
  def self.handleServerError(event)
    raise event if event.response.nil?

    error = QuidaxServerError.new(e.response)
    error_reponse_code = error.response.status

    case error_reponse_code
    when 400
      raise error,
            "HTTP Code 400: Bad request. Review the data sent in the request. Usually, this means a required piece of information is missing"
    when 401
      raise error,
            "HTTP Code 401: Unauthorized. This happens when you provide an invalid or non-existent secret API key"
    when 404
      raise error, "HTTP Code 404: Resource not found. The data requested does not exist."
    when 403
      raise error, "HTTP Code 403: Forbidden. Not enough permission to perform this operation"
    when 429
      raise error, "HTTP Code 429: You're making too many requests!"
    when 500, 501, 502, 503, 504
      raise error, "HTTP Code #{error_reponse_code}: Server Error. Something went wrong."
    end
  end
end
