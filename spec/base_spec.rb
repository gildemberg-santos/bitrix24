# frozen_string_literal: true

require "spec_helper"

describe Bitrix24::Common do
  it "Validar url" do
    expect do
      Bitrix24.validate_url(nil)
    end.to(raise_error(an_instance_of(Bitrix24::InvalidURIError).and(having_attributes(message: "URL is must be an String"))))
    expect do
      Bitrix24.validate_url("")
    end.to(raise_error(an_instance_of(Bitrix24::InvalidURIError).and(having_attributes(message: "URL is required"))))
    expect do
      Bitrix24.validate_url("String aleatoria")
    end.to(raise_error(an_instance_of(Bitrix24::InvalidURIError).and(having_attributes(message: "URL is invalid"))))
  end

  it "Validar url ?" do
    expect(Bitrix24.validate_url?("https://www.google.com")).to(eq(true))
    expect(Bitrix24.validate_url?("http://www.google.com")).to(eq(true))
    expect(Bitrix24.validate_url?("www.google.com")).to(eq(false))
    expect(Bitrix24.validate_url?("google.com")).to(eq(false))
    expect(Bitrix24.validate_url?("google")).to(eq(false))
    expect(Bitrix24.validate_url?("")).to(eq(false))
    expect(Bitrix24.validate_url?(nil)).to(eq(false))
  end

  it "Validar lead" do
    expect do
      Bitrix24.validate_lead(nil)
    end.to(raise_error(an_instance_of(Bitrix24::Error).and(having_attributes(message: "Lead fields is required"))))
  end

  it "Validar lead id" do
    expect do
      Bitrix24.validate_lead_id(nil)
    end.to(raise_error(an_instance_of(Bitrix24::Error).and(having_attributes(message: "Lead id must be an integer"))))
  end

  it "Validar email" do
    expect(Bitrix24.validate_email(nil)).to(eq(""))
    expect(Bitrix24.validate_email("")).to(eq(""))
    expect(Bitrix24.validate_email([])).to(eq(""))
    expect(Bitrix24.validate_email({})).to(eq(""))
    expect(Bitrix24.validate_email("teste@Teste.com  </br>")).to(eq("teste@teste.com"))
    expect(Bitrix24.validate_email("teste@teste.com")).to(eq("teste@teste.com"))
  end

  it "Criar string id" do
    expect(Bitrix24.string_id(nil)).to(eq(""))
    expect(Bitrix24.string_id("")).to(eq(""))
    expect(Bitrix24.string_id([])).to(eq(""))
    expect(Bitrix24.string_id({})).to(eq(""))
    expect(Bitrix24.string_id(1)).to(eq("ID=1"))
  end

  it "Criar uri" do
    expect(Bitrix24.create_uri("https://teste.com.br/", "teste", nil)).to(eq(URI("https://teste.com.br/teste.json")))
    expect(Bitrix24.create_uri("https://teste.com.br/", "teste", "teste")).to(eq(URI("https://teste.com.br/teste.json?teste")))
    expect(Bitrix24.create_uri("https://teste.com.br", "teste", "teste")).to(eq(URI("https://teste.com.br/teste.json?teste")))
  end

  it "Criar Hash" do
    lead_base = {
      TITLE: "TDD",
      NAME: "Test Lead",
      PHONE: "123456789",
      EMAIL: "teste@teste.com",
      BIRTHDATE: "11-05-1993",
      WEB: "http://www.teste.com",
      UTM_TERM: "https://www.teste.com.br/?utm_source=teste01&utm_medium=teste02&utm_campaign=teste03&utm_content=teste04&utm_term=teste05",
    }

    lead_result = {
      "FIELDS[BIRTHDATE]" => Date.new(1993, 5, 11),
      "FIELDS[TITLE]" => "TDD",
      "FIELDS[NAME]" => "Test Lead",
      "FIELDS[PHONE][0][VALUE]" => "123456789",
      "FIELDS[EMAIL][0][VALUE]" => "teste@teste.com",
      "FIELDS[WEB][0][VALUE]" => "http://www.teste.com",
      "FIELDS[UTM_TERM]" => "https://www.teste.com.br/?utm_source=teste01&utm_medium=teste02&utm_campaign=teste03&utm_content=teste04&utm_term=teste05",
    }
    expect(Bitrix24.create_hash(lead_base)).to(eq(lead_result))
  end

  it "Query de Leads" do
    lead_base = {
      TITLE: "TDD",
      NAME: "Test Lead",
      PHONE: "123456789",
      EMAIL: "teste@teste.com",
      BIRTHDATE: "11-05-1993",
      UTM_TERM: "https://www.teste.com.br/?utm_source=teste01&utm_medium=teste02&utm_campaign=teste03&utm_content=teste04&utm_term=teste05",
    }
    query_url_base = "FIELDS[TITLE]=TDD&FIELDS[NAME]=Test Lead&FIELDS[PHONE][0][VALUE]=123456789&FIELDS[EMAIL][0][VALUE]=teste@teste.com&FIELDS[BIRTHDATE]=1993-05-11&FIELDS[UTM_TERM]=https://www.teste.com.br/?utm_source=teste01&utm_medium=teste02&utm_campaign=teste03&utm_content=teste04&utm_term=teste05&"

    expect(Bitrix24.parse_fields_to_string(lead_base)).to(eq(query_url_base))
  end

  it "Converter Data" do
    expect(Bitrix24.parse_string_to_date("")).to(eq(nil))
    expect(Bitrix24.parse_string_to_date("2012-12-12")).to(eq(Date.new(2012, 12, 12)))
    expect(Bitrix24.parse_string_to_date("12-12-2012")).to(eq(Date.new(2012, 12, 12)))
    expect(Bitrix24.parse_string_to_date("1993-05-11")).to(eq(Date.new(1993, 5, 11)))
    expect(Bitrix24.parse_string_to_date("11-05-1993")).to(eq(Date.new(1993, 5, 11)))
  end
end
