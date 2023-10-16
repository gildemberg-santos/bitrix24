# frozen_string_literal: true

module Bitrix24
  class RequestV2
    attr_reader :json, :status_code

    def initialize(url, fields = {})
      raise Bitrix24::InvalidURIError, "URL is required" unless Utils.url?(url)

      @url = url
      @fields = fields
    end

    def call
      request
    end

    private

    attr_reader :url, :fields

    def request
      response = HTTParty.post(url, body: fields.to_json, headers: headers)

      @status_code = response.code.to_i
      @json = response.deep_symbolize_keys

      raise_error
    end

    def headers
      { "Content-Type": "application/json" }
    end

    def raise_error
      if status_code != 200 && json[:error] == "PORTAL_DELETED"
        raise Bitrix24::InvalidURIError, json[:error_description]
      end

      raise Bitrix24::Error, json[:error_description] if status_code != 200
    end
  end
end
