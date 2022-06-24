# frozen_string_literal: true

module Bitrix24
  class Base
    def blank?(value)
      value.nil? || value.to_s.empty? || value.to_s.strip.empty?
    end
  end
end
