# frozen_string_literal: true

module Bitrix24
  # Request class for Bitrix24
  class Request
    def initialize(url, fields = {})
      raise Bitrix24::InvalidURIError, 'URL is required' if url.blank?

      @url = url
      @fields = fields
      @response = nil
    end

    def get
      @response = http
      json
      if status_code != 200
        if json['error'] == 'PORTAL_DELETED'
          raise Bitrix24::InvalidURIError, json['error_description']
        end

        raise Bitrix24::Error, json['error_description']
      end
    end

    def json
      JSON.parse(@response.body)
    rescue JSON::ParserError
      raise Bitrix24::InvalidURIError, 'URL invalid'
    end

    def status_code
      @response.code.to_i
    end

    private

    def request_http
      request = Net::HTTP::Post.new(@url.request_uri)
      request['Content-Type'] = 'application/json'
      request.set_form_data @fields if @fields.present?
      request
    end

    def http
      http = Net::HTTP.new(@url.host, @url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.request(request_http)
    end
  end
end
