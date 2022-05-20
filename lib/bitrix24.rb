# frozen_string_literal: true

require_relative "bitrix24/version"
require 'yaml'
require 'uri'
require 'httparty'

module Bitrix24
  class Error < StandardError; end

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

  attr_accessor :api_url

  def self.api_url(url)
    @api_url = url
  end

  def self.add(params)
    fields = parse_fields(params)
    uri = URI("#{@api_url}#{ENDPOINT_ADD}.json")
    uri.query = fields
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  end

  def self.delete(params)
    fields = parse_fields(params)
    uri = URI("#{@api_url}#{ENDPOINT_DELETE}.json")
    uri.query = fields
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  end

  def self.get(id)
    fields = "ID=#{id}"
    uri = URI("#{@api_url}#{ENDPOINT_GET}.json")
    uri.query = fields
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  rescue Error => e
    puts e.message
  end

  def self.list
    uri = URI("#{@api_url}#{ENDPOINT_LIST}.json")
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  end

  def self.update(params)
    fields = parse_fields(params)
    uri = URI("#{@api_url}#{ENDPOINT_UPDATE}.json")
    uri.query = fields
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  end

  def self.list_fields
    uri = URI("#{@api_url}#{ENDPOINT_FIELDS}.json")
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  end

  def self.add_fiels_custom(id)
    id = id.gsub("UF_CRM_", "")
    fields = "FIELDS[FIELD_NAME]=#{id}"
    uri = URI("#{@api_url}#{ENDPOINT_ADD_CUSTOM}.json")
    uri.query = fields
    result = HTTParty.get(uri.to_s)
    result['result'] if result.code == 200
  end

  def self.parse_fields(fields)
    query = ""
    fields.each do |key, value|
      if key == "EMAIL" || key == "PHONE"
        query += "FIELDS[#{key}][0][VALUE]=#{value}"
      else
        query += "FIELDS[#{key}]=#{value}&"
      end
    end
    query.gsub("FIELDS[ID]", "ID") if query.include?("FIELDS[ID]")
    query.slice 0..-2
  end

  def self.fields_custom_merge(fields_leads, fields_custom)
    fields = {}
    fields.merge!(fields_leads) if fields_leads.class == Hash
    if fields_custom.class == Array
      fields_custom.each { |field| fields.merge!({ field[:name] => field[:value] }) if field[:name].present? && field[:value].present? }
    elsif fields_custom.class == Hash
      fields.merge!({ fields_custom[:name] => fields_custom[:value] })
    end
    fields
  end
end
