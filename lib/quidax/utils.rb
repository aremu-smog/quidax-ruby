# frozen_string_literal: true

require_relative "error"

# Base Util
module Utils
  def self.handle_server_error(event)
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

  def self.check_missing_keys(required_keys:, keys:, field:)
    keys.map!(&:to_s)
    missing_keys = required_keys - keys
    has_missing_keys = missing_keys.empty?
    error_message = "missing key(s) in :#{field} #{missing_keys.join(", ")}"

    raise ArgumentError, error_message unless has_missing_keys
  end

  def self.validate_value_in_array(array:, value:, field:)
    error_message = ":#{field} must be one of: #{array.join(", ")}"

    raise ArgumentError, error_message unless array.include?(value)
  end

  def self.validate_value_in_range(range:, value:, field:)
    raise ArgumentError, "#{field} must be between #{range}" unless range.include?(value.to_i)
  end
end
