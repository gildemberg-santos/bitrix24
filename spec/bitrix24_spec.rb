# frozen_string_literal: true

require "yaml"
require "uri"
require "json"
require "net/http"
require "active_support/time"
require "logger"
require "bitrix24/version"
require "bitrix24/endpoint"
require "bitrix24/base"
require "bitrix24/debug"
require "bitrix24/error"
require "bitrix24/request"
require "bitrix24"

include Bitrix24

LEAD_BASE = { TITLE: "TDD", NAME: "Test Lead", PHONE: "123456789", EMAIL: "teste@teste.com" }.freeze
FIELD_CUSTOM_BASE = { name: "TEST_TDD", value: "Teste" }.freeze
LEAD_CUSTOM_BASE = { TEST_TDD: "Teste" }.freeze
MERGE_CUSTOM_BASE = { TITLE: "TDD", NAME: "Test Lead", PHONE: "123456789", EMAIL: "teste@teste.com",
                      TEST_TDD: "Teste", }.freeze
URL_BASE = "https://b24-8d71jf.bitrix24.com.br/rest/1/fbyoqtsl8xlg2m6d/"
URL_BASE_ERRO = "https://b24-8d71jf.bitrix24.com.br/rest/1/fbyoqtsl8xlgrm6d/"
ID_BASE = 270
DATA_BASE = "1970-05-01"

describe Bitrix24::Common do
  before(:all) do
    @bitrix24 = Bitrix24::Common.new
    @bitrix24.url = URL_BASE_ERRO
  end
  it {
    expect do
      @bitrix24.add(URL_BASE_ERRO)
    end.to(raise_error(an_instance_of(Bitrix24::Error)))
  }
end

describe Bitrix24::Common do
  before(:all) do
    @bitrix24 = Bitrix24::Common.new
    @bitrix24.url = URL_BASE
  end

  it { expect(@bitrix24.add(LEAD_BASE)["result"].present?).to(eq(true)) }

  it { expect { @bitrix24.add(nil)["result"] }.to(raise_error(an_instance_of(Bitrix24::Error))) }

  it {
    expect(
      @bitrix24.add(
        @bitrix24.merge_fields_and_custom_fields(LEAD_BASE, FIELD_CUSTOM_BASE)
      )["result"].present?
    ).to(eq(true))
  }

  it { expect(@bitrix24.merge_fields_and_custom_fields(LEAD_BASE, FIELD_CUSTOM_BASE)).to(eq(MERGE_CUSTOM_BASE)) }

  it { expect(@bitrix24.merge_fields_and_custom_fields(nil, FIELD_CUSTOM_BASE)).to(eq(LEAD_CUSTOM_BASE)) }

  it { expect(@bitrix24.merge_fields_and_custom_fields(LEAD_BASE, nil)).to(eq(LEAD_BASE)) }
end
