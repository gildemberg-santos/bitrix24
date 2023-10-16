# frozen_string_literal: true

require "spec_helper"

describe Bitrix24::CreateLead do
  subject(:service) { described_class.new(url, lead_fields, custom_fields).call }

  let(:url) { "https://b24-oyew5y.bitrix24.com.br/rest/1/2zrkgdgw1xtatp6q/" }
  let(:lead_fields) { { "TITLE" => "Test" } }
  let(:custom_fields) { [{"name" => "TEST_DD", "value" => "VALOR_ADD"}] }
  let(:fields) { { "FIELDS[TITLE]": "Test", "FIELDS[TEST_DD]": "VALOR_ADD" } }
  let(:code) { 200 }
  let(:body) { fields.to_json }

  before do
    WebMock.enable!

    stub_request(:post, "#{url}crm.lead.add.json")
      .with(
        body: body,
        headers: { "Content-Type": "application/json" }
      )
      .to_return(
        status: code,
        body: {}.to_json,
        headers: { "Content-Type": "application/json" }
      )
  end

  describe "#call" do
    context "when success" do
      it { expect(service).to be_nil }
    end

    context "when failure" do
      let(:code) { 404 }
      let(:body) { { error: nil, error_description: "Portal deleted" }.to_json }

      it { expect { service }.to raise_error(Bitrix24::Error, "Portal deleted") }
    end
  end
end
