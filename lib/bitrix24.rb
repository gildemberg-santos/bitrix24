# frozen_string_literal: true

require "yaml"
require "uri"
require "json"
require "net/http"
require "active_support/time"
require "logger"
require "openssl"
require "httparty"

module Bitrix24; end

require "bitrix24/utils"
require "bitrix24/version"
require "bitrix24/endpoint"
require "bitrix24/debug"
require "bitrix24/error"
require "bitrix24/request_v2"
require "bitrix24/create_lead"
