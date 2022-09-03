# frozen_string_literal: true

module Bitrix24
  def self.validate_url(url)
    raise Bitrix24::InvalidURIError, "URL is required" if url.blank?
    raise Bitrix24::InvalidURIError, "URL is invalid" unless Bitrix24.validate_url?(url)
  end

  def self.validate_lead(lead)
    raise Bitrix24::Error, "Lead fields is required" if lead.blank?
  end

  def self.validate_lead_id(id)
    raise Bitrix24::Error, "Lead id must be an integer" unless id.is_a?(Integer)
    raise Bitrix24::Error, "Lead id is required" if id.blank?
  end

  def self.validate_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end
end
