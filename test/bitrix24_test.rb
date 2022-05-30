require "minitest/autorun"
require_relative '../lib/bitrix24'
include Bitrix24

LEAD_BASE = {:TITLE => "TDD", :NAME => "Test Lead", :PHONE => "123456789", :EMAIL => "teste@teste.com"}
FIELD_CUSTOM_BASE = {:name => "TEST_TDD", :value => "Teste"}
LEAD_CUSTOM_BASE = {:TEST_TDD => "Teste"}
MERGE_CUSTOM_BASE = {:TITLE => "TDD", :NAME => "Test Lead", :PHONE => "123456789", :EMAIL => "teste@teste.com", :TEST_TDD => "Teste"}
URL_BASE = 'https://b24-aniahy.bitrix24.com/rest/1/rhalk97du9rb3wrq/'
ID_BASE = 270
DATA_BASE = "1970-05-01"

describe 'Bitrix' do
  before "Start api url" do
    Bitrix24.api_url(URL_BASE)
  end

  describe "Send lead to integration" do
    it "Correct Data" do
      result = Bitrix24.add(LEAD_BASE)
      expect(result).to eq(true)
    end

    it "Incorrect Data" do
      result = Bitrix24.add(nil)
      expect(result).to eq(false)
    end

    it "Custom compounds" do
      custom = Bitrix24.merge_fields_and_custom_fields(LEAD_BASE, FIELD_CUSTOM_BASE)
      result = Bitrix24.add(custom)
      expect(result).to eq(true)
    end
  end

  describe "Search lead sent for integration" do
    if "Search Lead ID 270"
      it "Correct Data" do
        lead = Bitrix24.get(ID_BASE)
        expect(lead["ID"].to_i).to eq(ID_BASE)
      end
    end
  end

  describe "Fields" do
    it "Merge" do
      fields = Bitrix24.merge_fields_and_custom_fields(LEAD_BASE, FIELD_CUSTOM_BASE)
      expect(fields).to eq(MERGE_CUSTOM_BASE)
    end

    it "Merge leads nil" do
      fields = Bitrix24.merge_fields_and_custom_fields(nil, FIELD_CUSTOM_BASE)
      expect(fields).to eq(LEAD_CUSTOM_BASE)
    end

    it "Merge custom nil" do
      fields = Bitrix24.merge_fields_and_custom_fields(LEAD_BASE, nil)
      expect(fields).to eq(LEAD_BASE)
    end
  end

  describe "Date" do
    it "parse nil" do
      date = Bitrix24.parse_string_to_date(nil)
      expect(date.class).to eq(NilClass)
    end

    it "parse string 01.05.1970" do
      date = Bitrix24.parse_string_to_date("01.05.1970")
      expect(date.to_s).to eq(DATA_BASE)
    end

    it "parse string 01/05/1970" do
      date = Bitrix24.parse_string_to_date("01/05/1970")
      expect(date.to_s).to eq(DATA_BASE)
    end

    it "parse string 1970-05-01" do
      date = Bitrix24.parse_string_to_date("1970-05-01")
      expect(date.to_s).to eq(DATA_BASE)
    end

    it "parse string emputy" do
      date = Bitrix24.parse_string_to_date("")
      expect(date.to_s).to_not eq(DATA_BASE)
    end

    it "parse string number" do
      date = Bitrix24.parse_string_to_date("13213")
      expect(date.to_s).to_not eq(DATA_BASE)
    end

    it "parse string random" do
      date = Bitrix24.parse_string_to_date("sdgfsgf3213fd")
      expect(date.to_s).to_not eq(DATA_BASE)
    end
  end

end
