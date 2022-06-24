# frozen_string_literal: true

module Bitrix24
  class Error < StandardError
    def initialize(*args)
      super(*args)
      if Bitrix24.debug?
        Dir.mkdir('log') unless Dir.exist?('log')
        log = Logger.new('log/bitrix.log', 0, 100 * 1024 * 1024)
        log.debug(args)
      end
    end
  end
end
