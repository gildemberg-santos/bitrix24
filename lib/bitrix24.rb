# frozen_string_literal: true

require_relative "bitrix24/version"
require 'yaml'
require 'uri'
require 'httparty'

module Bitrix24
  # Default fields endpoint
  ENDPOINT_ADD = "crm.lead.add".freeze
  ENDPOINT_DELETE = "crm.lead.delete".freeze
  ENDPOINT_GET = "crm.lead.get".freeze
  ENDPOINT_LIST = "crm.lead.list".freeze
  ENDPOINT_UPDATE = "crm.lead.update".freeze
  ENDPOINT_FIELDS = "crm.lead.fields".freeze

  # After custom fields
  ENDPOINT_ADD_CUSTOM = "crm.lead.userfield.add".freeze
  ENDPOINT_GET_CUSTOM = "crm.lead.userfield.get".freeze

  attr_accessor :url

  def self.api_url(url)
    @url ||= url
  end

  def self.request_execute(endpoint, params=nil, id=nil)
    fields = ""
    fields = parse_fields_to_string(params) if params.is_a?(Hash)
    fields += "ID=#{id}" if id.is_a?(Integer)
    fields ||= id if id.is_a?(Integer)
    uri = URI("#{@url}#{endpoint}.json")
    uri.query = fields
    result = HTTParty.get(uri.to_s)
    result.code == 200
  rescue StandardError => e
    raise e
  end

  def self.request_select(endpoint, id=nil)
    fields = nil
    fields = "ID=#{id}" if id.is_a?(Integer)
    uri = URI("#{@url}#{endpoint}.json")
    uri.query = fields if fields.is_a?(String)
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  rescue StandardError => e
    raise e
  end

  def self.add(params)
    request_execute(ENDPOINT_ADD, params)
  end

  def self.get(id)
    request_select(ENDPOINT_GET, id)
  end

  def self.parse_fields_to_string(fields)
    query = ""
    fields.each do |key, value|
      value = parse_string_to_date(value) if key == "BIRTHDATE"
      if key == "EMAIL" || key == "PHONE"
        query += "FIELDS[#{key}][0][VALUE]=#{value}&"
      else
        query += "FIELDS[#{key}]=#{value}&"
      end
    end
    query.gsub("FIELDS[ID]", "ID") if query.include?("FIELDS[ID]")
    query.slice 0..-2
  rescue StandardError => e
    puts e.message
  end

  def self.merge_fields_and_custom_fields(fields_leads, fields_custom)
    fields = {}
    fields.merge!(fields_leads) if fields_leads.class == Hash
    fields.merge!(parse_array_to_object(fields_custom)) if fields_custom.class == Array
    fields.merge!({ fields_custom[:name] => fields_custom[:value] }) if fields_custom.class == Hash
    fields
  rescue StandardError => e
    puts e.message
  end

  def self.parse_array_to_object(fields_custom=[])
    fields = {}
    fields_custom.each do |field|
      field = eval(field.to_json) unless field.nil?
      next if field.nil? || field[:name].nil? || field[:value].nil?
      fields.merge!({ field[:name] => field[:value] })
    end
    fields
  rescue StandardError => e
    puts e.message
  end

  def self.parse_string_to_date(value)
    Date.parse(value)
  rescue StandardError => e
    puts e.message
  end
end
