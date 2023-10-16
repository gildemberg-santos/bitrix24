# frozen_string_literal: true

module Bitrix24
  class CreateLead
    attr_accessor :url, :update_lead

    def initialize(url, lead_fields, custom_fields)
      @url = url
      @params = Utils.merge_fields_and_custom_fields(lead_fields, custom_fields)

      Utils.validate_lead(@params)
      Utils.validate_url(@url)
    end

    def call
      request_execute(ENDPOINT_ADD, @params)
    end

    private

    def request_execute(endpoint, params, id = nil)
      params = JSON.parse(params.to_json)
      fields_post = Utils.parse_to_payload(params) if params.is_a?(Hash)
      result =
        RequestV2.new(
          Utils.build_uri(@url, endpoint, Utils.query_id(id)),
          fields_post
        )
      result.call
    end
  end
end
