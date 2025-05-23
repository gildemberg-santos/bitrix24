# frozen_string_literal: true

module Bitrix24
  class Util
    def self.url?(url)
      return false if !url.is_a?(String) || url.blank? || !url.match?(URI::DEFAULT_PARSER.make_regexp(%w[http https]))

      true
    end

    def self.email?(email)
      return false if !email.is_a?(String) || email.blank? || !email.match?(URI::MailTo::EMAIL_REGEXP)

      true
    end

    def self.query_id(id)
      return "" unless id.is_a?(Integer)

      "ID=#{id}"
    end

    def self.deep_symbolize_keys(hash)
      return hash if !hash.is_a?(Hash) || hash.blank?

      hash.deep_symbolize_keys
    end

    def self.parse_to_date(value)
      value.to_date
    rescue StandardError
      nil
    end

    def self.parse_to_payload(fields)
      result = {}
      field_roles = %i[EMAIL PHONE WEB IM]
      fields = deep_symbolize_keys(fields)

      fields.each do |key, value|
        value = parse_to_date(value) if key == :BIRTHDATE
        next result.merge!("FIELDS[#{key}][0][VALUE]": value) if field_roles.include?(key)

        result.merge!("FIELDS[#{key}]": value)
      end

      result
    end

    def self.validate_url(url)
      return if url?(url)

      raise Bitrix24::Errors::InvalidURIError, "URL is invalid"
    end

    def self.validate_lead(lead)
      raise Bitrix24::Errors::GeneralError, "Lead fields is required" if lead.blank?
    end

    def self.validate_lead_id(id)
      raise Bitrix24::Errors::GeneralError, "Lead id must be an integer" unless id.is_a?(Integer)
    end

    def self.build_uri(url_base, endpoint, query)
      raise Bitrix24::Errors::GeneralError, "URL base is required" if url_base.blank?
      raise Bitrix24::Errors::GeneralError, "Endpoint is required" if endpoint.blank?

      url_base = url_base[0...-1] if url_base[-1] == "/"
      uri = URI("#{url_base}/#{endpoint}.json")
      uri.query = query if query.is_a?(String)
      uri.to_s
    end

    def self.merge_fields_and_custom_fields(fields_leads, fields_custom)
      fields = {}
      fields_leads = deep_symbolize_keys(fields_leads)
      fields_custom = deep_symbolize_keys(fields_custom)

      fields.merge!(fields_leads) if fields_leads.instance_of?(Hash)
      fields.merge!(parse_array_to_object(fields_custom)) if fields_custom.instance_of?(Array)
      fields[fields_custom[:name]] = fields_custom[:value] if fields_custom.instance_of?(Hash)

      deep_symbolize_keys(fields)
    end

    def self.parse_array_to_object(fields_custom = [])
      fields = {}
      fields_custom.each do |field|
        field = deep_symbolize_keys(field)
        next if field.nil? || field[:name].nil? || field[:value].nil?

        fields.merge!(deep_symbolize_keys({ field[:name] => field[:value] }))
      end
      fields
    end
  end
end
