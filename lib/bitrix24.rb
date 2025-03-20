# frozen_string_literal: true

require "active_support/all"
require "httparty"
require "u-case"

module Bitrix24; end

Dir[File.join(__dir__, "bitrix24", "**", "*.rb")].sort.each { |file| require file }
