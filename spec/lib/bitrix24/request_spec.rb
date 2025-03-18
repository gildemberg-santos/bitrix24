# frozen_string_literal: true

require "spec_helper"

RSpec.describe Bitrix24::Request do
  subject { described_class.call(url: url, fields: fields) }

  let(:url) { "https://b24-iq2a30.bitrix24.com.br/rest/1/onkpa24vwd18zi90/crm.lead.add.json" }
  let(:fields) { { "fields" => { "TITLE" => "Test" } } }

  describe "#call" do
    context "when success" do
      it "returns the expected response" do
        VCR.use_cassette("request_success", record: :none) do
          expect(subject).to be_success
          expect(subject.data[:json][:result]).to eq(19)
        end
      end
    end

    context "when failure" do
      let(:url) { "https://b24-iq2a30.bitrix24.com.br/rest/1/invalid/crm.lead.add.json" }

      it "raises an error" do
        VCR.use_cassette("request_failure", record: :none) do
          expect(subject).to be_failure
          expect(subject.data[:error]).to eq("Invalid request credentials")
        end
      end
    end
  end
end
