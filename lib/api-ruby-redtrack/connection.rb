module RubyRedtrack
  class Connection
    attr_accessor :email, :token, :expire_at

    def initialize(email = nil, password = nil, token = nil)
      @email     = email
      @password  = password
      @token     = token
      # Redtrack token lives 4 hours after last used. Suppose it was used
      # recently to give it a try. If it's not valid anymore, the script
      # get a new one in authenticate! method.
      @expire_at = @token ? (Time.now.utc + 4 * 86_400) : nil
    end

    def get(path, query = {})
      authenticatable_request(:get, path, nil, query)
    end

    def post(path, payload)
      authenticatable_request(:post, path, payload)
    end

    def put(path, payload)
      authenticatable_request(:put, path, payload)
    end

    def delete(path, payload)
      authenticatable_request(:delete, path, payload)
    end

    def authenticate!
      response = request(
        :post, 'auth/session',
        email: @email, password: @password
      )
      @token     = response['token']
      @expire_at = Time.parse(response['expirationTimestamp'])
    end

    def authenticated?
      !@token.nil? && !@expire_at.nil? && @expire_at > Time.now.utc
    end

    private

    def authenticatable_request(method, path, payload = {}, query = {})
      authenticate! unless authenticated?
      begin
        request(method, path, payload, query)
      rescue RestClient::Unauthorized
        authenticate!
        request(method, path, payload, query)
      end
    end

    def request(method, url, payload = {}, query = {})
      JSON.parse(
        RestClient::Request.execute(
          url:     "#{API_URL}/#{url}",
          method:  method,
          payload: payload.to_json,
          headers: headers(query)
        ) do |response, request, result|
          Logger.log(response, request, result)
          raise RestClient::Unauthorized if result.code_type == Net::HTTPUnauthorized
          response
        end
      )
    rescue JSON::ParserError
      nil
    end

    def headers(query = {})
      headers = {
        'content-type' => 'application/json',
        'cwauth-token' => @token
      }
      headers['params'] = query if query.any?
      headers
    end
  end
end
