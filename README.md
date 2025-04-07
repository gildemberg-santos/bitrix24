# Bitrix24 Ruby Gem

[![Build Status](https://github.com/gildemberg-santos/bitrix24/actions/workflows/main.yml/badge.svg)](https://github.com/gildemberg-santos/bitrix24/actions)

Uma gem Ruby para integração com a API do Bitrix24. Permite criar e manipular leads, contatos e outras entidades dentro do seu ambiente Bitrix24 de forma prática e extensível.

---

## 📦 Instalação

### Adicionando ao Gemfile

```ruby
gem "bitrix24", git: "https://github.com/gildemberg-santos/bitrix24"
```

Depois execute:

```bash
bundle install
```

### Instalação manual

```bash
gem install pkg/bitrix24-x.y.z.gem
```

> 💡 Substitua `x.y.z` pela versão apropriada do pacote `.gem`.

---

## 🚀 Uso

### Criar um lead

```ruby
require "bitrix24"

Bitrix24::Services::CreateLead.call(
  url: "https://your-domain.bitrix24.com.br/rest/1/your-api-key",
  lead_fields: {
    TITLE: "Título do lead",
    NAME: "Nome",
    LAST_NAME: "Sobrenome",
    PHONE: "Telefone",
    EMAIL: "E-mail",
    SOURCE_ID: "Origem do lead",
    STATUS_ID: "Status do lead",
    ASSIGNED_BY_ID: "ID do responsável",
    UF_CRM_1619027320: "Campo personalizado"
  },
  contact_fields: [{ name: "TEST_DD", value: "VALOR_ADD" }]
)
```

---

## ⚠️ Forma Antiga (Depreciada)

```ruby
require "bitrix24"

bitrix24 = Bitrix24::Common.new

fields_merge = bitrix24.merge_fields_and_custom_fields(
  {
    TITLE: "Título do lead",
    NAME: "Nome",
    LAST_NAME: "Sobrenome",
    PHONE: "Telefone",
    EMAIL: "E-mail",
    SOURCE_ID: "Origem do lead",
    STATUS_ID: "Status do lead",
    ASSIGNED_BY_ID: "ID do responsável",
    UF_CRM_1619027320: "Campo personalizado"
  },
  [{ name: "TEST_DD", value: "VALOR_ADD" }]
)

bitrix24.url = "https://your-domain.bitrix24.com.br/rest/1/your-api-key"
bitrix24.add(fields_merge)
```

> ⚠️ Essa abordagem foi substituída pela interface mais moderna via `Bitrix24::Services::CreateLead`.

---

## 🛠 Desenvolvimento

Após clonar o repositório, configure o ambiente de desenvolvimento com:

```bash
bin/setup
```

Para abrir um console interativo com a gem carregada:

```bash
bin/console
```

### Instalar a gem localmente

```bash
bundle exec rake install
```

### Publicar nova versão

1. Atualize a versão em `lib/bitrix24/version.rb`
2. Execute:

```bash
bundle exec rake release
```

Esse processo:

- Cria uma tag no Git com a nova versão
- Envia os commits e a tag para o GitHub
- Publica o pacote no [RubyGems.org](https://rubygems.org)

---

## 🤝 Contribuindo

Contribuições são sempre bem-vindas! Para reportar bugs ou sugerir melhorias, utilize o [repositório oficial no GitHub](https://github.com/gildemberg-santos/bitrix24).

Todos os participantes devem seguir o nosso [Código de Conduta](https://github.com/gildemberg-santos/bitrix24/blob/master/CODE_OF_CONDUCT.md).

---

## 📄 Licença

Este projeto está disponível sob os termos da [Licença MIT](https://opensource.org/licenses/MIT).
