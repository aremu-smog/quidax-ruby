class QuidaxBaseObject
    require 'json'

    attr_reader :quidax

    def initialize(quidaxObject)
        raise ArgumentError.new("Quidax object cannot be nil!") unless quidaxObject != nil
        @quidax = quidaxObject
    end

    
    def self.get_request(q_object, path)
        result = nil
        begin
            response = Faraday.get(url(path), {}, {"Authorization" => "Bearer #{q_object.secret_key}"}) 
             
            raise QuidaxServerError.new(response) unless response.status == 200 || response.status == 201
            result = JSON.parse(response.body)
        rescue QuidaxServerError => e
            Utils.handleServerError(e)
            return response
        rescue JSON::ParserError => jsonerr
            raise QuidaxServerError.new(response) , "Invalid result data. Could not parse JSON response body \n #{jsonerr.message}" 
        end
        return result
    end

    def self.post_request(q_object, path, body={})
        result = nil
 
        begin
            response = Faraday.post(url(path), body.to_json, {"Authorization" => "Bearer #{q_object.secret_key}", "Content-Type" => "application/json", "Accept" => "application/json"})
            raise QuidaxServerError.new(response) unless response.status == 200 || response.status == 201
            result = JSON.parse(response.body)
        rescue QuidaxServerError => e
            Utils.handleServerError(e)
        end
        return result
    end

    def self.put_request(q_object, path, body={})
        result = nil
       
        options[:body] = body unless body == nil
        begin
            response = Faraday.put("#{API::BASE_URL}#{path}", body, {"Authorization" => "Bearer #{q_object.secret_key}"})
            raise QuidaxServerError.new(response) unless response.status == 200 || response.status == 201
            result = JSON.parse(response.body)
        rescue QuidaxServerError => e
            Utils.handleServerError(e)
        end
    end

    protected
    def self.url path
        "#{API::BASE_URL}#{path}"
    end

end