# frozen_string_literal: true

require "spec_helper"

RSpec.describe Bitrix24::Common do
  # subject { described_class.call(url: url, lead_fields: lead_fields, custom_fields: custom_fields) }

  let(:url) { "https://b24-iq2a30.bitrix24.com.br/rest/1/onkpa24vwd18zi90/" }
  let(:lead_fields) { { "TITLE" => "Test" } }
  let(:custom_fields) { [{ "name" => "TEST_DD", "value" => "VALOR_ADD" }] }

  describe "#call" do
    context "when success" do
      it "returns the expected response" do
        VCR.use_cassette("create_lead_success", record: :none) do
          bitrix24 = Bitrix24::Common.new

          fields_merge = bitrix24.merge_fields_and_custom_fields(lead_fields, custom_fields)
          bitrix24.url = url
          result = bitrix24.add(fields_merge)

          expect(result).to be_success
          expect(result.data[:json][:result]).to eq(23)
        end
      end
    end

    context "when failure" do
      let(:url) { "https://b24-iq2a30.bitrix24.com.br/rest/1/invalid/" }

      it "raises an error" do
        VCR.use_cassette("create_lead_failure", record: :none) do
          bitrix24 = Bitrix24::Common.new

          fields_merge = bitrix24.merge_fields_and_custom_fields(lead_fields, custom_fields)
          bitrix24.url = url

          expect { bitrix24.add(fields_merge) }.to raise_error(Bitrix24::Error)
        end
      end
    end
  end
end
