# frozen_string_literal: true

require "yaml"
require "uri"
require "json"
require "net/http"
require "active_support/all"
require "logger"
require "openssl"
require "httparty"
require "u-case"

module Bitrix24; end

Dir[File.join(__dir__, "bitrix24", "**", "*.rb")].sort.each { |file| require file }
