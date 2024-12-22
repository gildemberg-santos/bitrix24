# frozen_string_literal: true

require "spec_helper"

RSpec.describe Bitrix24::Utils do
  subject(:util) { described_class }

  describe ".url?" do
    context "when url is invalid" do
      it { expect(util.url?(false)).to be(false) }
      it { expect(util.url?(nil)).to be(false) }
      it { expect(util.url?("")).to be(false) }
      it { expect(util.url?("www.teste.com")).to be(false) }
    end

    context "when url is valid" do
      it { expect(util.url?("http://www.teste.com")).to be(true) }
      it { expect(util.url?("https://www.teste.com")).to be(true) }
    end
  end

  describe ".email?" do
    context "when email is invalid" do
      it { expect(util.email?(false)).to be(false) }
      it { expect(util.email?(nil)).to be(false) }
      it { expect(util.email?("")).to be(false) }
      it { expect(util.email?("teste.com")).to be(false) }
      it { expect(util.email?("person test@teste.com")).to be(false) }
      it { expect(util.email?("person_test@teste.com <br>")).to be(false) }
    end

    context "when email is valid" do
      it { expect(util.email?("person_test@teste.com")).to be(true) }
    end
  end

  describe ".query_id" do
    context "when id is invalid" do
      it { expect(util.query_id(false)).to eq("") }
      it { expect(util.query_id(nil)).to eq("") }
      it { expect(util.query_id("")).to eq("") }
      it { expect(util.query_id("teste")).to eq("") }
    end

    context "when id is valid" do
      it { expect(util.query_id(1)).to eq("ID=1") }
    end
  end

  describe ".deep_symbolize_keys" do
    context "when hash is invalid" do
      it { expect(util.deep_symbolize_keys(false)).to be_falsy }
      it { expect(util.deep_symbolize_keys(nil)).to be_nil }
      it { expect(util.deep_symbolize_keys("")).to eq("") }
    end

    context "when hash is valid" do
      it { expect(util.deep_symbolize_keys({})).to eq({}) }
      it { expect(util.deep_symbolize_keys({ "test" => "test" })).to eq({ test: "test" }) }

      it {
        expect(util.deep_symbolize_keys({ "test" => { "test" => "test" } })).to eq({ test: { test: "test" } })
      }
    end
  end

  describe ".parse_to_date" do
    context "when value is invalid" do
      it { expect(util.parse_to_date(false)).to be_nil }
      it { expect(util.parse_to_date(nil)).to be_nil }
      it { expect(util.parse_to_date("")).to be_nil }
      it { expect(util.parse_to_date("teste")).to be_nil }
    end

    context "when value is valid" do
      it { expect(util.parse_to_date("2020-01-01")).to eq(Date.new(2020, 1, 1)) }
    end
  end

  describe ".parse_to_payload" do
    context "when fields is invalid" do
      it { expect { util.parse_to_payload(false) }.to raise_error(NoMethodError) }
      it { expect { util.parse_to_payload(nil) }.to raise_error(NoMethodError) }
      it { expect { util.parse_to_payload("") }.to raise_error(NoMethodError) }
    end

    context "when fields is valid" do
      it { expect(util.parse_to_payload({ "TEST" => "T" })).to eq({ "FIELDS[TEST]": "T" }) }
      it { expect(util.parse_to_payload({ "EMAIL" => "T" })).to eq({ "FIELDS[EMAIL][0][VALUE]": "T" }) }
      it { expect(util.parse_to_payload({ "PHONE" => "T" })).to eq({ "FIELDS[PHONE][0][VALUE]": "T" }) }
      it { expect(util.parse_to_payload({ "WEB" => "T" })).to eq({ "FIELDS[WEB][0][VALUE]": "T" }) }
      it { expect(util.parse_to_payload({ "IM" => "T" })).to eq({ "FIELDS[IM][0][VALUE]": "T" }) }
    end
  end

  describe ".parse_array_to_object" do
    context "when array is invalid" do
      it { expect { util.parse_array_to_object(nil) }.to raise_error(NoMethodError) }
      it { expect { util.parse_array_to_object("") }.to raise_error(NoMethodError) }
    end

    context "when array is valid" do
      it { expect(util.parse_array_to_object([])).to eq({}) }
      it { expect(util.parse_array_to_object([{ "name" => "name", "value" => "Gildemberg" }])).to eq({ name: "Gildemberg" }) }
    end
  end

  describe ".validate_url" do
    context "when url is valid" do
      it { expect { util.validate_url("https://www.google.com") }.not_to raise_error }
    end

    context "when url is invalid" do
      it { expect { util.validate_url("") }.to raise_error(Bitrix24::InvalidURIError, "URL is invalid") }
    end
  end

  describe ".validate_lead" do
    context "when lead is valid" do
      it { expect { util.validate_lead({ name: "" }) }.not_to raise_error }
    end

    context "when lead is invalid" do
      it { expect { util.validate_lead(nil) }.to raise_error(Bitrix24::Error, "Lead fields is required") }
    end
  end

  describe ".validate_lead_id" do
    context "when lead id is valid" do
      it { expect { util.validate_lead_id(1) }.not_to raise_error }
    end

    context "when lead id is invalid" do
      it { expect { util.validate_lead_id(nil) }.to raise_error(Bitrix24::Error, "Lead id must be an integer") }
    end
  end

  describe ".build_uri" do
    context "when uri is valid" do
      it { expect(util.build_uri("https://t.com.br/", "q", nil)).to eq("https://t.com.br/q.json") }
      it { expect(util.build_uri("https://t.com.br/", "q", "v")).to eq("https://t.com.br/q.json?v") }
      it { expect(util.build_uri("https://t.com.br", "q", "v")).to eq("https://t.com.br/q.json?v") }
    end

    context "when uri is invalid" do
      it { expect { util.build_uri(nil, "q", "v") }.to raise_error(Bitrix24::Error, "URL base is required") }
      it { expect { util.build_uri("https://t.com.br", nil, "v") }.to raise_error(Bitrix24::Error, "Endpoint is required") }
    end
  end
end
