class QuidaxBaseObject

    attr_reader :quidax

    def initialize(quidaxObject)
        raise ArgumentError.new("Quidax object cannot be nil!") unless quidaxObject != nil
        @quidax = quidaxObject
    end

    def self.get_request(q_object, path)

        result = nil
        begin
        response = HTTParty.get("#{API::BASE_URL}#{path}", {
            headers: {
                "Authorization": "Bearer #{q_object.secret_key}"
            }
        })
        raise QuidaxServerError.new(response) unless response.code == 200 || response.code == 201
        result = response.body
        rescue QuidaxServerError(e)
            Utils.handleServerError(e)
        end
        return result
    end

    def self.post_request(q_object, path, body=nil)
        result = nil
        options = {
                headers: {"Authorization": "Bearer #{q_object.secret_key}"}
            }
        options[:body] = body unless body == nil
        
        begin
            response = HTTParty.post("#{API::BASE_URL}#{path}", options)
            raise QuidaxServerError.new(response) unless response.code == 200 || response.code == 201
            result = response.body
        rescue QuidaxServerError(e)
            Utils.handleServerError(e)
        end
        return result
    end

    def self.put_request(q_boject, path, body=nil)
        result = nil
        options = {
            headers: {"Authorization": "Bearer #{q_object.secret_key}"}
        }
        options[:body] = body unless body == nil
        begin
            response = HTTParty.put("#{API::BASE_URL}#{path}", options)
            raise QuidaxServerError.new(response) unless response.code == 200 || response.code == 201
            result = response.body
        rescue QuidaxServerError(e)
            Utils.handleServerError(e)
        end
    end

end