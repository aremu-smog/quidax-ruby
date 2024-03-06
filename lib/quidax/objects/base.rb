# frozen_string_literal: true

# Base object for HTTP requests
class QuidaxBaseObject
  require "json"

  attr_reader :quidax

  def initialize(quidaxObject)
    raise ArgumentError, "Quidax object cannot be nil!" if quidaxObject.nil?

    @quidax = quidaxObject
  end

  def self.get_request(q_object, path, params = {})
    result = nil
    begin
      response = Faraday.get(url(path), params, { "Authorization" => "Bearer #{q_object.secret_key}" })

      raise QuidaxServerError, response unless response.status == 200 || response.status == 201

      result = JSON.parse(response.body)
    rescue QuidaxServerError => e
      Utils.handle_server_error(e)
      return response
    rescue JSON::ParserError => e
      raise QuidaxServerError.new(response),
            "Invalid result data. Could not parse JSON response body \n #{e.message}"
    end
    result
  end

  def self.post_request(q_object, path, body = {})
    result = nil

    begin
      response = Faraday.post(url(path), body.to_json,
                              { "Authorization" => "Bearer #{q_object.secret_key}", "Content-Type" => "application/json", "Accept" => "application/json" })
      raise QuidaxServerError, response unless response.status == 200 || response.status == 201

      result = JSON.parse(response.body)
    rescue QuidaxServerError => e
      Utils.handle_server_error(e)
    end
    result
  end

  def self.put_request(q_object, path, body = {})
    response = Faraday.put("#{API::BASE_URL}#{path}", body,
                           { "Authorization" => "Bearer #{q_object.secret_key}" })
    raise QuidaxServerError, response unless response.status == 200 || response.status == 201

    JSON.parse(response.body)
  rescue QuidaxServerError => e
    Utils.handle_server_error(e)
  end

  def self.url(path)
    "#{API::BASE_URL}#{path}"
  end
end
