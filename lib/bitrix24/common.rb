# frozen_string_literal: true

module Bitrix24
  class Common
    attr_accessor :url, :update_lead

    def add(params)
      Bitrix24.validate_lead(params)
      Bitrix24.validate_url(@url)

      request_execute(ENDPOINT_ADD, params)
    end

    def get(id)
      Bitrix24.validate_lead_id(id)
      Bitrix24.validate_url(@url)

      request_select(ENDPOINT_GET, id)
    end

    def merge_fields_and_custom_fields(fields_leads, fields_custom)
      fields = {}
      fields_leads = Bitrix24.normalize_hash(fields_leads)
      fields_custom = Bitrix24.normalize_hash(fields_custom)
      fields.merge!(fields_leads) if fields_leads.instance_of?(Hash)
      fields.merge!(parse_array_to_object(fields_custom)) if fields_custom.instance_of?(Array)
      fields.merge!({ fields_custom[:name] => fields_custom[:value] }) if fields_custom.instance_of?(Hash)
      Bitrix24.normalize_hash(fields)
    rescue Bitrix24::Error => e
      raise e
    end

    def request_execute(endpoint, params, id = nil)
      params = JSON.parse(params.to_json)
      fields_url = ""
      fields_post = {}
      # fields_url += Bitrix24.parse_fields_to_string(params) if params.is_a?(Hash)
      fields_post = Bitrix24.create_hash(params) if params.is_a?(Hash)
      fields_url += Bitrix24.string_id(id)
      fields_url ||= id if id.is_a?(Integer)
      result = Bitrix24::Request.new(Bitrix24.create_uri(@url, endpoint, fields_url), fields_post)
      result.get
      result.json
    end

    def request_select(endpoint, id = nil)
      fields = ""
      fields += Bitrix24.string_id(id)
      result = Bitrix24::Request.new(Bitrix24.create_uri(@url, endpoint, fields))
      result.get
      result.json
    end

    def parse_array_to_object(fields_custom = [])
      fields = {}
      fields_custom.each do |field|
        field = Bitrix24.normalize_hash(field)
        next if field.nil? || field[:name].nil? || field[:value].nil?

        fields.merge!({ field[:name] => field[:value] })
      end
      fields
    end
  end
end
