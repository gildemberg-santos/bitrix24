# frozen_string_literal: true

module Bitrix24
  @debug = false

  def self.debug=(value)
    @debug = value
  end

  def self.debug?
    @debug
  end

  def self.logger
    if Bitrix24.debug?
      Dir.mkdir('log') unless Dir.exist?('log')
      log = Logger.new('log/bitrix.log', 0, 100 * 1024 * 1024)
      log.debug(args)
    end
  end
end
