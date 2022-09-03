# frozen_string_literal: true

module Bitrix24
  class Request
    attr_reader :json, :status_code
    attr_writer :access_token

    def initialize(url)
      raise Bitrix24::Error, "URL is required" if url.blank?

      @url = url
    end

    def get
      uri = URI.parse(@url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      request["Content-Type"] = "application/json"
      responde = http.request(request)

      @json = JSON.parse(responde.body)
      @status_code = responde.code.to_i

      raise Bitrix24::Error, @json["error_description"] if @status_code != 200
    rescue Bitrix24::Error => e
      raise e
    end
  end
end
