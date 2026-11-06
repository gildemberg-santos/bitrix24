# Bitrix24 Ruby Gem

[![Build Status](https://github.com/gildemberg-santos/bitrix24/actions/workflows/main.yml/badge.svg)](https://github.com/gildemberg-santos/bitrix24/actions)

[Português](README.pt-BR.md)

A Ruby gem for the Bitrix24 API. It lets you create and manage leads, contacts and other entities in your Bitrix24 account in a practical, extensible way.

---

## 📦 Installation

### Add it to your Gemfile

```ruby
gem "bitrix24", git: "https://github.com/gildemberg-santos/bitrix24"
```

Then run:

```bash
bundle install
```

### Manual installation

```bash
gem install pkg/bitrix24-x.y.z.gem
```

> 💡 Replace `x.y.z` with the version of the `.gem` package.

---

## 🚀 Usage

### Create a lead

```ruby
require "bitrix24"

Bitrix24::Services::CreateLead.call(
  url: "https://your-domain.bitrix24.com.br/rest/1/your-api-key",
  lead_fields: {
    TITLE: "Lead title",
    NAME: "First name",
    LAST_NAME: "Last name",
    PHONE: "Phone",
    EMAIL: "Email",
    SOURCE_ID: "Lead source",
    STATUS_ID: "Lead status",
    ASSIGNED_BY_ID: "Owner ID",
    UF_CRM_1619027320: "Custom field"
  },
  contact_fields: [{ name: "TEST_DD", value: "VALOR_ADD" }]
)
```

---

## ⚠️ Legacy interface (deprecated)

```ruby
require "bitrix24"

bitrix24 = Bitrix24::Common.new

fields_merge = bitrix24.merge_fields_and_custom_fields(
  {
    TITLE: "Lead title",
    NAME: "First name",
    LAST_NAME: "Last name",
    PHONE: "Phone",
    EMAIL: "Email",
    SOURCE_ID: "Lead source",
    STATUS_ID: "Lead status",
    ASSIGNED_BY_ID: "Owner ID",
    UF_CRM_1619027320: "Custom field"
  },
  [{ name: "TEST_DD", value: "VALOR_ADD" }]
)

bitrix24.url = "https://your-domain.bitrix24.com.br/rest/1/your-api-key"
bitrix24.add(fields_merge)
```

> ⚠️ This approach was replaced by the more modern `Bitrix24::Services::CreateLead` interface.

---

## 🛠 Development

After cloning the repository, set up the development environment with:

```bash
bin/setup
```

To open an interactive console with the gem loaded:

```bash
bin/console
```

### Install the gem locally

```bash
bundle exec rake install
```

### Release a new version

1. Update the version in `lib/bitrix24/version.rb`
2. Run:

```bash
bundle exec rake release
```

This process:

- Creates a Git tag for the new version
- Pushes the commits and the tag to GitHub
- Publishes the package to [RubyGems.org](https://rubygems.org)

---

## 🤝 Contributing

Contributions are welcome! To report bugs or suggest improvements, use the [GitHub repository](https://github.com/gildemberg-santos/bitrix24).

All participants are expected to follow the [Code of Conduct](https://github.com/gildemberg-santos/bitrix24/blob/master/CODE_OF_CONDUCT.md).

---

## 📄 License

Available under the terms of the [MIT License](https://opensource.org/licenses/MIT).
