# frozen_string_literal: true

require "spec_helper"

RSpec.describe Bitrix24::CreateLead do
  subject(:service) { described_class.call(url: url, lead_fields: lead_fields, custom_fields: custom_fields) }

  let(:url) { "https://b24-iq2a30.bitrix24.com.br/rest/1/onkpa24vwd18zi90/" }
  let(:lead_fields) { { "TITLE" => "Test" } }
  let(:custom_fields) { [{ "name" => "TEST_DD", "value" => "VALOR_ADD" }] }
  let(:fields) { { "FIELDS[TITLE]": "Test", "FIELDS[TEST_DD]": "VALOR_ADD" } }
  let(:code) { 200 }
  let(:body) { fields.to_json }

  describe "#call" do
    context "when success" do
      it "returns the expected response" do
        VCR.use_cassette("create_lead_success", record: :new_episodes) do
          expect(service).to be_success
        end
      end
    end

    context "when failure" do
      let(:code) { 404 }
      let(:body) { { error: nil, error_description: "Portal deleted" }.to_json }

      it { expect { service }.to raise_error(Bitrix24::Error, "Portal deleted") }
    end
  end
end
