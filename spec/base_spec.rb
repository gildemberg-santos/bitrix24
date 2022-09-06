require 'spec_helper'

describe Bitrix24::Common do
  it "Validar url" do
    expect { Bitrix24.validate_url(nil) }.to(raise_error(an_instance_of(Bitrix24::InvalidURIError).and having_attributes(message: 'URL is must be an String')))
    expect { Bitrix24.validate_url('') }.to(raise_error(an_instance_of(Bitrix24::InvalidURIError).and having_attributes(message: 'URL is required')))
    expect { Bitrix24.validate_url("String aleatoria") }.to(raise_error(an_instance_of(Bitrix24::InvalidURIError).and having_attributes(message: 'URL is invalid')))
  end

  it "Validar url ?" do
    expect(Bitrix24.validate_url?("https://www.google.com")).to eq(true)
    expect(Bitrix24.validate_url?("http://www.google.com")).to eq(true)
    expect(Bitrix24.validate_url?("www.google.com")).to eq(false)
    expect(Bitrix24.validate_url?("google.com")).to eq(false)
    expect(Bitrix24.validate_url?("google")).to eq(false)
    expect(Bitrix24.validate_url?("")).to eq(false)
    expect(Bitrix24.validate_url?(nil)).to eq(false)
  end

  it "Validar lead" do
    expect { Bitrix24.validate_lead(nil) }.to(raise_error(an_instance_of(Bitrix24::Error).and having_attributes(message: 'Lead fields is required')))
  end

  it "Validar lead id" do
    expect { Bitrix24.validate_lead_id(nil) }.to(raise_error(an_instance_of(Bitrix24::Error).and having_attributes(message: 'Lead id must be an integer')))
  end

  it "Validar email" do
    expect(Bitrix24.validate_email(nil)).to eq("")
    expect(Bitrix24.validate_email("")).to eq("")
    expect(Bitrix24.validate_email([])).to eq("")
    expect(Bitrix24.validate_email({})).to eq("")
    expect(Bitrix24.validate_email("teste@Teste.com  </br>")).to eq("teste@teste.com")
    expect(Bitrix24.validate_email("teste@teste.com")).to eq("teste@teste.com")
  end

  it "Criar string id" do
    expect(Bitrix24.string_id(nil)).to eq("")
    expect(Bitrix24.string_id("")).to eq("")
    expect(Bitrix24.string_id([])).to eq("")
    expect(Bitrix24.string_id({})).to eq("")
    expect(Bitrix24.string_id(1)).to eq("ID=1")
  end

  it "Criar uri" do
    expect(Bitrix24.create_uri("https://teste.com.br/", "teste", nil)).to eq(URI("https://teste.com.br/teste.json"))
    expect(Bitrix24.create_uri("https://teste.com.br/", "teste", "teste")).to eq(URI("https://teste.com.br/teste.json?teste"))
    expect(Bitrix24.create_uri("https://teste.com.br", "teste", "teste")).to eq(URI("https://teste.com.br/teste.json?teste"))
  end
end
