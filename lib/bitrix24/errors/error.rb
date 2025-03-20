# frozen_string_literal: true

module Bitrix24
  module Errors
    class GeneralError < StandardError; end
    class InvalidURIError < GeneralError; end
  end
end
