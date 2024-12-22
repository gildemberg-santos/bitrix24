# frozen_string_literal: true

require "spec_helper"

RSpec.describe Bitrix24::CreateLead do
  subject { described_class.call(url: url, lead_fields: lead_fields, custom_fields: custom_fields) }

  let(:url) { "https://b24-iq2a30.bitrix24.com.br/rest/1/onkpa24vwd18zi90/" }
  let(:lead_fields) { { "TITLE" => "Test" } }
  let(:custom_fields) { [{ "name" => "TEST_DD", "value" => "VALOR_ADD" }] }

  describe "#call" do
    context "when success" do
      it "returns the expected response" do
        VCR.use_cassette("create_lead_success", record: :none) do
          expect(subject).to be_success
          expect(subject.data[:json][:result]).to eq(23)
        end
      end
    end

    context "when failure" do
      let(:url) { "https://b24-iq2a30.bitrix24.com.br/rest/1/invalid/" }

      it "raises an error" do
        VCR.use_cassette("create_lead_failure", record: :none) do
          expect(subject).to be_failure
          expect(subject.data[:error]).to eq("Invalid request credentials")
        end
      end
    end
  end
end
