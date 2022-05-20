# frozen_string_literal: true

require_relative "bitrix24/version"
require 'yaml'
require 'uri'
require 'httparty'

module Bitrix24
  class Error < StandardError; end

  attr_writer :api_url

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

  def add(params)
    fields = parse_fields(params)
    uri = URI("#{@api_url}#{ENDPOINT_ADD}.json")
    uri.query = fields
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  end

  def delete(params)
    fields = parse_fields(params)
    uri = URI("#{@api_url}#{ENDPOINT_DELETE}.json")
    uri.query = fields
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  end

  def get(id)
    fields = "ID=#{id}"
    uri = URI("#{@api_url}#{ENDPOINT_GET}.json")
    uri.query = fields
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  end

  def list
    uri = URI("#{@api_url}#{ENDPOINT_LIST}.json")
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  end

  def update(params)
    fields = parse_fields(params)
    uri = URI("#{@api_url}#{ENDPOINT_UPDATE}.json")
    uri.query = fields
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  end

  def list_fields
    uri = URI("#{@api_url}#{ENDPOINT_FIELDS}.json")
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  end

  def add_fiels_custom(id)
    id = id.gsub("UF_CRM_", "")
    fields = "FIELDS[FIELD_NAME]=#{id}"
    uri = URI("#{@api_url}#{ENDPOINT_ADD_CUSTOM}.json")
    uri.query = fields
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  end

  def parse_fields(fields)
    query = ""
    fields.each do |key, value|
      query += "FIELDS[#{key}]=#{value}&"
    end
    query.gsub("FIELDS[ID]", "ID") if query.include?("FIELDS[ID]")
    query.slice 0..-2
  end
end
