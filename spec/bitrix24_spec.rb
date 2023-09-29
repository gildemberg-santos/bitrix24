# frozen_string_literal: true

LEAD_BASE = {
  TITLE: 'TDD',
  NAME: 'Test Lead',
  PHONE: '123456789',
  EMAIL: 'teste@teste.com',
  WEB: 'https://www.teste.com',
  UTM_TERM: 'https://www.teste.com.br/?utm_source=teste01&utm_medium=teste02&utm_campaign=teste03&utm_content=teste04&utm_term=teste05'
}.freeze

FIELD_CUSTOM_BASE = { name: 'TEST_TDD', value: 'Teste' }.freeze
FIELD_CUSTOM_BASE_2 = [{ name: 'TEST_TDD', value: 'Teste' }].freeze
LEAD_CUSTOM_BASE = { TEST_TDD: 'Teste' }.freeze
MERGE_CUSTOM_BASE = {
  TITLE: 'TDD',
  NAME: 'Test Lead',
  PHONE: '123456789',
  EMAIL: 'teste@teste.com',
  TEST_TDD: 'Teste',
  UTM_TERM: 'https://www.teste.com.br/?utm_source=teste01&utm_medium=teste02&utm_campaign=teste03&utm_content=teste04&utm_term=teste05',
  WEB: 'https://www.teste.com'
}.freeze

URL_BASE = 'https://b24-oyew5y.bitrix24.com.br/rest/1/2zrkgdgw1xtatp6q/'
URL_BASE_ERRO = 'https://b24-8d71jf.bitrix24.com.br/rest/1/fbyoqtsl8xlgrm6d/'
ID_BASE = 270
DATA_BASE = '1970-05-01'

describe Bitrix24::Common do
  before(:all) do
    @bitrix24 = Bitrix24::Common.new
    @bitrix24.url = URL_BASE_ERRO
    @bitrix24_url_erro = Bitrix24::Common.new
    @bitrix24_url_erro.url = 'String aleatoria'
  end

  it 'Url invalida' do
    expect do
      @bitrix24.add(URL_BASE_ERRO)
    end.to(raise_error(an_instance_of(Bitrix24::InvalidURIError)))
  end

  it 'Url invalida com testo aleatorio' do
    expect do
      @bitrix24_url_erro.add(URL_BASE_ERRO)
    end.to(raise_error(an_instance_of(Bitrix24::InvalidURIError)))
  end
end

describe Bitrix24::Common do
  before(:all) do
    @bitrix24 = Bitrix24::Common.new
    @bitrix24.url = URL_BASE
  end

  it 'Cadastrar Lead' do
    expect(@bitrix24.add(LEAD_BASE)['result'].present?).to(eq(true))
  end

  it 'Cadastrar Lead vazio' do
    expect { @bitrix24.add(nil)['result'] }.to(raise_error(an_instance_of(Bitrix24::Error)))
  end

  it 'Cadastrar Lead com Lead Custom' do
    expect(
      @bitrix24.add(
        @bitrix24.merge_fields_and_custom_fields(LEAD_BASE, FIELD_CUSTOM_BASE)
      )['result'].present?
    ).to(eq(true))
  end

  it 'Mesclar Lead base com Lead Custom' do
    expect(@bitrix24.merge_fields_and_custom_fields(LEAD_BASE, FIELD_CUSTOM_BASE)).to(eq(MERGE_CUSTOM_BASE))
  end

  it 'Mesclar Lead base com Lead Custom Array' do
    expect(@bitrix24.merge_fields_and_custom_fields(LEAD_BASE, FIELD_CUSTOM_BASE_2)).to(eq(MERGE_CUSTOM_BASE))
  end

  it 'Mesclar Lead base nil com Lead Custom' do
    expect(@bitrix24.merge_fields_and_custom_fields(nil, FIELD_CUSTOM_BASE)).to(eq(LEAD_CUSTOM_BASE))
  end

  it 'Mesclar Lead base com Lead Custom nil' do
    expect(@bitrix24.merge_fields_and_custom_fields(LEAD_BASE, nil)).to(eq(LEAD_BASE))
  end
end
