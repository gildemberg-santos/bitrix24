# frozen_string_literal: true

module Bitrix24
  module Services
    class CreateLead < Micro::Case
      attributes :url, :lead_fields, :custom_fields

      def call!
        @url = url
        @params = Util.merge_fields_and_custom_fields(lead_fields, custom_fields)

        Util.validate_lead(params)
        Util.validate_url(url)

        request_execute(Bitrix24::Endpoints::Lead::ENDPOINT_ADD, params)
      end

      private

      attr_reader :url, :update_lead, :params

      def request_execute(endpoint, params, id = nil)
        params = JSON.parse(params.to_json)
        fields_post = Util.parse_to_payload(params) if params.is_a?(Hash)

        Request.call(
          url: Util.build_uri(@url, endpoint, Util.query_id(id)),
          fields: fields_post
        )
      end
    end
  end
end
