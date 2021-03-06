# Skebby

**DISCONTINUED: We're not using Skebby anymore, so this gem is not being
maintained. For an alternative, see the [Skuby](https://github.com/welaika/skuby).**

[![Gem Version](https://badge.fury.io/rb/skebby.png)](http://badge.fury.io/rb/skebby)
[![Build Status](https://travis-ci.org/interconn-isp/skebby.png?branch=master)](https://travis-ci.org/interconn-isp/skebby)
[![Dependency Status](https://gemnasium.com/interconn-isp/skebby.png)](https://gemnasium.com/interconn-isp/skebby)
[![Code Climate](https://codeclimate.com/github/interconn-isp/skebby.png)](https://codeclimate.com/github/interconn-isp/skebby)

This is a Ruby gem providing a wrapper around [Skebby](http://www.skebby.it/)'s RESTful API.

## Installation

Add this line to your application's Gemfile:

    gem 'skebby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install skebby

## Usage

### Initialize the client

To initialize the API client you only need to provide your credentials:

```ruby
skebby = Skebby::Client.new(username: 'john.doe', password: 'foobar')
```

### Check the remaining credit

```ruby
skebby.get_credit # { credit_left: 1.61972, classic_sms: 25, basic_sms: 35 }
```

### Send an SMS (SMS Classic)

```ruby
skebby.send_sms_classic(
  recipients: ['393459187391', '393786104981'],
  text:       'Hello, world!'
) # { remaining_sms: 5 }
```

(Note: You can provide other parameters. For more info, check [Skebby's docs](http://www.skebby.it/business/index/send-docs/)).

### Send an SMS (SMS Basic)

```ruby
skebby.send_sms_basic(
  recipients: ['393459187391', '393786104981'],
  text:       'Hello, world!'
) # { remaining_sms: 5 }
```

(Note: You can provide other parameters. For more info, check [Skebby's docs](http://www.skebby.it/business/index/send-docs/)).

### Send an SMS and request a read-receipt (SMS Classic Plus)

```ruby
skebby.send_sms_classic_report(
  recipients: ['393459187391', '393786104981'],
  text:       'Hello, world!'
) # { remaining_sms: 5, dispatch_id: 1392562134 }
```

(Note: You can provide other parameters. For more info, check [Skebby's docs](http://www.skebby.it/business/index/send-docs/)).

## Contributing

1. [Fork it](http://github.com/interconn/skebby/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
