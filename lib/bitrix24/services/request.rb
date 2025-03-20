# frozen_string_literal: true

module Bitrix24
  module Services
    class Request < Micro::Case
      attributes :url, :fields

      def call!
        raise Bitrix24::Errors::InvalidURIError, "URL is required" unless Util.url?(url)

        @url = url
        @fields = fields

        request

        Success result: { json: json, status_code: status_code }
      rescue Bitrix24::Errors::InvalidURIError => e
        Failure(:invalid_uri, result: { error: e.message })
      rescue Bitrix24::Errors::GeneralError => e
        Failure(:error, result: { error: e.message })
      end

      private

      attr_reader :url, :fields, :json, :status_code

      def request
        response = HTTParty.post(url, body: fields, headers: headers)

        @status_code = response.code.to_i
        @json = JSON.parse(response.body).deep_symbolize_keys

        raise_error
      end

      def headers
        { "Content-Type": "application/x-www-form-urlencoded" }
      end

      def raise_error
        if status_code != 200 && json[:error] == "PORTAL_DELETED"
          raise Bitrix24::Errors::InvalidURIError, json[:error_description]
        end

        raise Bitrix24::Errors::GeneralError, json[:error_description] if status_code != 200
      end
    end
  end
end
