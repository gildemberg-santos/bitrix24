# frozen_string_literal: true

module Bitrix24
  def self.validate_url(url)
    unless url.is_a?(String)
      raise Bitrix24::InvalidURIError, 'URL is must be an String'
    end
    raise Bitrix24::InvalidURIError, 'URL is required' if url.blank?
    unless Bitrix24.validate_url?(url)
      raise Bitrix24::InvalidURIError, 'URL is invalid'
    end
  end

  def self.validate_lead(lead)
    raise Bitrix24::Error, 'Lead fields is required' if lead.blank?
  end

  def self.validate_lead_id(id)
    raise Bitrix24::Error, 'Lead id must be an integer' unless id.is_a?(Integer)
  end

  def self.validate_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP || URI::HTTPS) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  def self.validate_email(email)
    return '' unless email.is_a?(String)

    regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    email.match?(regex) ? email.downcase.gsub(' ', '').gsub('/', '').gsub('<br>', '') : ''
  end

  def self.create_uri(url_base, endpoint, query)
    url_base = url_base[0...-1] if url_base[-1] == '/'
    uri = URI("#{url_base}/#{endpoint}.json")
    uri.query = query if query.is_a?(String)
    uri
  end

  def self.string_id(id)
    if id.is_a?(Integer)
      "ID=#{id}"
    else
      ''
    end
  end

  def self.create_hash(fields)
    fields = normalize_hash(fields) if fields.is_a?(Hash)
    result = {}
    fields.each do |key, value|
      value = parse_string_to_date(value) if key == :BIRTHDATE
      if %i[EMAIL PHONE WEB IM].include?(key)
        result.merge!("FIELDS[#{key}][0][VALUE]" => value) # , "FIELDS[#{key}][0][VALUE_TYPE]" => "WORK"
      else
        result.merge!("FIELDS[#{key}]" => value)
      end
    end
    result
  end

  def self.normalize_hash(value)
    return value unless value.is_a?(Hash) && value.present?

    value&.deep_symbolize_keys
  end

  def self.parse_fields_to_string(fields)
    query = ''
    fields.each do |key, value|
      value = parse_string_to_date(value) if key == :BIRTHDATE
      query += if %i[EMAIL PHONE WEB IM].include?(key)
                 "FIELDS[#{key}][0][VALUE]=#{value}&"
               else
                 "FIELDS[#{key}]=#{value}&"
      end
    end
    query.gsub('FIELDS[ID]', 'ID') if query.include?('FIELDS[ID]')
    query
  end

  def self.parse_string_to_date(value)
    Date.parse(value)
  rescue StandardError
    nil
  end
end
