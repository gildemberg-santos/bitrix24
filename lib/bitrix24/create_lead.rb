# frozen_string_literal: true

module Bitrix24
  class CreateLead < Micro::Case
    attributes :url, :lead_fields, :custom_fields

    def call!
      @url = url
      @params = Utils.merge_fields_and_custom_fields(lead_fields, custom_fields)

      Utils.validate_lead(params)
      Utils.validate_url(url)

      request_execute(ENDPOINT_ADD, params)
    end

    private

    attr_reader :url, :update_lead, :params

    def request_execute(endpoint, params, id = nil)
      params = JSON.parse(params.to_json)
      fields_post = Utils.parse_to_payload(params) if params.is_a?(Hash)

      Request.call(
        url: Utils.build_uri(@url, endpoint, Utils.query_id(id)),
        fields: fields_post
      )
    end
  end
end
