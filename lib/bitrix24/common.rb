# frozen_string_literal: true

module Bitrix24
  # TODO: Just to maintain compatibility with the original code
  class Common
    attr_accessor :url, :lead_fields, :custom_fields

    def initialize
      @url = nil
      @lead_fields = nil
      @custom_fields = nil
    end

    def merge_fields_and_custom_fields(lead_fields, custom_fields)
      @lead_fields = lead_fields
      @custom_fields = custom_fields
    end

    def add(_)
      response = Bitrix24::CreateLead.call(url: url, lead_fields: lead_fields, custom_fields: custom_fields)
      raise Bitrix24::Errors::GeneralError, response.data[:error] if response.failure?

      response
    end
  end
end
