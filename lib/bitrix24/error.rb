# frozen_string_literal: true

module Bitrix24
  class Error < StandardError
    def initialize(*args)
      super(*args)
      Bitrix24.logger
    end
  end

  class InvalidURIError < StandardError
    def initialize(*args)
      super(*args)
      Bitrix24.logger
    end
  end
end
