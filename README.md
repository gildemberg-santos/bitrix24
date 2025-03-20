# Bitrix24

![example workflow](https://github.com/gildemberg-santos/bitrix24/actions/workflows/main.yml/badge.svg)

Bitrix24 is a Ruby library for integration with the Bitrix24 API, allowing the creation and manipulation of leads, contacts, and other entities within Bitrix24.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "bitrix24", git: "https://github.com/gildemberg-santos/bitrix24", branch: "master"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install bitrix24

## Usage

To create a lead, you can use the following code:

```ruby
require "bitrix24"

Bitrix24::CreateLead.call(
    url: "https://your-domain.bitrix24.com.br/rest/1/your-api-key",
    lead_fields: {
        TITLE: "Lead title",
        NAME: "Lead name",
        LAST_NAME: "Lead last name",
        PHONE: "Lead phone",
        EMAIL: "Lead email",
        SOURCE_ID: "Lead source id",
        STATUS_ID: "Lead status id",
        ASSIGNED_BY_ID: "Lead assigned by id",
        UF_CRM_1619027320: "Lead custom field"
    },
    contact_fields: [{ "name": "TEST_DD", "value": "VALOR_ADD" }],
)
```

## Deprecated Usage

The following example demonstrates a deprecated way to create a lead:

```ruby
require "bitrix24"

bitrix24 = Bitrix24::Common.new

fields_merge = bitrix24.merge_fields_and_custom_fields(
  {
    TITLE: "Lead title",
    NAME: "Lead name",
    LAST_NAME: "Lead last name",
    PHONE: "Lead phone",
    EMAIL: "Lead email",
    SOURCE_ID: "Lead source id",
    STATUS_ID: "Lead status id",
    ASSIGNED_BY_ID: "Lead assigned by id",
    UF_CRM_1619027320: "Lead custom field"
  },
  [{ name: "TEST_DD", value: "VALOR_ADD" }]
)
bitrix24.url = "https://your-domain.bitrix24.com.br/rest/1/your-api-key"
bitrix24.add(fields_merge)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gildemberg-santos/bitrix24. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/gildemberg-santos/bitrix24/blob/master/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Bitrix24 project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/gildemberg-santos/bitrix24/blob/master/CODE_OF_CONDUCT.md).
