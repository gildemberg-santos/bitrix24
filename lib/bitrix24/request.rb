# frozen_string_literal: true

module Bitrix24
  # Request class for Bitrix24
  class Request
    def initialize(url)
      raise Bitrix24::InvalidURIError, "URL is required" if url.blank?

      @url = url
      @response = nil
    end

    def get
      @response = http
      json
      if status_code != 200
        raise Bitrix24::InvalidURIError, json["error_description"] if json["error"] == "PORTAL_DELETED"

        raise Bitrix24::Error, json["error_description"]
      end
    end

    def json
      JSON.parse(@response.body)
    end

    def status_code
      @response.code.to_i
    end

    private

    def request_http
      request = Net::HTTP::Get.new(@url.request_uri)
      request["Content-Type"] = "application/json"
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
