# frozen_string_literal: true

module Bitrix24
  def self.validate_url(url)
    raise Bitrix24::InvalidURIError, "URL is must be an String" unless url.is_a?(String)
    raise Bitrix24::InvalidURIError, "URL is required" if url.blank?
    raise Bitrix24::InvalidURIError, "URL is invalid" unless Bitrix24.validate_url?(url)
  end

  def self.validate_lead(lead)
    raise Bitrix24::Error, "Lead fields is required" if lead.blank?
  end

  def self.validate_lead_id(id)
    raise Bitrix24::Error, "Lead id must be an integer" unless id.is_a?(Integer)
  end

  def self.validate_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP || URI::HTTPS) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  def self.validate_email(email)
    return "" unless email.is_a?(String)

    email.match?(/.*@.*/) ? email.downcase.gsub(" ", "").gsub("/", "").gsub("<br>", "") : ""
  end

  def self.create_uri(url_base, endpoint, query)
    url_base = url_base[0...-1] if url_base[-1] == "/"
    uri = URI("#{url_base}/#{endpoint}.json")
    uri.query = query if query.is_a?(String)
    uri
  end

  def self.string_id(id)
    if id.is_a?(Integer)
      "ID=#{id}"
    else
      ""
    end
  end
end
