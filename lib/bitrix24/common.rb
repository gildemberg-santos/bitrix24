# frozen_string_literal: true

module Bitrix24
  class Common < Bitrix24::Base
    attr_accessor :url

    def add(params)
      raise Bitrix24::Error, 'Lead fields is required' if blank? params

      request_execute(ENDPOINT_ADD, params)
    rescue Bitrix24::Error => e
      raise e
    end

    def get(id)
      raise Bitrix24::Error, 'Id is required' if blank? id

      request_select(ENDPOINT_GET, id)
    rescue Bitrix24::Error => e
      raise e
    end

    def merge_fields_and_custom_fields(fields_leads, fields_custom)
      fields = {}
      fields_leads = normalize_hash(fields_leads)
      fields_custom = normalize_hash(fields_custom)
      fields.merge!(fields_leads) if fields_leads.instance_of?(Hash)
      fields.merge!(parse_array_to_object(fields_custom)) if fields_custom.instance_of?(Array)
      fields.merge!({ fields_custom[:name] => fields_custom[:value] }) if fields_custom.instance_of?(Hash)
      normalize_hash(fields)
    rescue Bitrix24::Error => e
      raise e
    end

    private

    def parse_fields_to_string(fields)
      query = ''
      fields.each do |key, value|
        value = parse_string_to_date(value) if key == :BIRTHDATE
        query += if %w[EMAIL PHONE].include?(key)
                   "FIELDS[#{key}][0][VALUE]=#{value}&"
                 else
                   "FIELDS[#{key}]=#{value}&"
                 end
      end
      query.gsub('FIELDS[ID]', 'ID') if query.include?('FIELDS[ID]')
      query.slice 0..-2
    rescue Bitrix24::Error => e
      raise e
    end

    def request_execute(endpoint, params, id = nil)
      params = JSON.parse(params.to_json)
      fields = ''
      fields = parse_fields_to_string(params) if params.is_a?(Hash)
      fields += "ID=#{id}" if id.is_a?(Integer)
      fields ||= id if id.is_a?(Integer)
      uri = URI("#{@url}#{endpoint}.json")
      uri.query = fields
      result = Bitrix24::Request.new(uri.to_s)
      result.get
      result.json
    rescue Bitrix24::Error => e
      raise e
    end

    def request_select(endpoint, id = nil)
      fields = nil
      fields = "ID=#{id}" if id.is_a?(Integer)
      uri = URI("#{@url}#{endpoint}.json")
      uri.query = fields if fields.is_a?(String)
      result = Bitrix24::Request.new(uri.to_s)
      result.get
      result.json
    rescue Bitrix24::Error => e
      raise e
    end

    def parse_array_to_object(fields_custom = [])
      fields = {}
      fields_custom.each do |field|
        field = normalize_hash(field)
        next if field.nil? || field[:name].nil? || field[:value].nil?

        fields.merge!({ field[:name] => field[:value] })
      end
      fields
    rescue Bitrix24::Error => e
      raise e
    end

    def parse_string_to_date(value)
      Date.parse(value)
    rescue StandardError
      nil
    end

    def normalize_hash(value)
      eval(value.to_json) unless value.nil?
    rescue Bitrix24::Error => e
      raise e
    end
  end
end
