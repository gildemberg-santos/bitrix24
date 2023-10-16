# frozen_string_literal: true

require "spec_helper"

describe Bitrix24::RequestV2 do
  subject(:service) { described_class.new(url, fields) }

  let(:url) { "https://b24-oyew5y.bitrix24.com.br/rest/1/2zrkgdgw1xtatp6q/" }
  let(:fields) { { "fields" => { "TITLE" => "Test" } } }
  let(:code) { 200 }
  let(:body) { fields.to_json }

  before do
    WebMock.enable!
    stub_request(:post, url)
      .with(
        body: fields.to_json,
        headers: { "Content-Type": "application/json" }
      )
      .to_return(
        status: code,
        body: body,
        headers: { "Content-Type": "application/json" }
      )
  end

  describe "#call" do
    context "when success" do
      before { service.call }

      it { expect(service.json).to eq("fields": { "TITLE": "Test" }) }
    end

    context "when failure" do
      let(:code) { 404 }
      let(:body) { { error: nil, error_description: "Portal deleted" }.to_json }

      it { expect { service.call }.to raise_error(Bitrix24::Error, "Portal deleted") }
    end

    context "when failure PORTAL_DELETED" do
      let(:code) { 404 }
      let(:body) { { error: "PORTAL_DELETED", error_description: "Portal deleted" }.to_json }

      it { expect { service.call }.to raise_error(Bitrix24::InvalidURIError, "Portal deleted") }
    end
  end
end
