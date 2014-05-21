# OmniAuth Aveda PurePro

An OmniAuth strategy to authenticate against the proprietary Aveda PurePro JSON-RPC API.

https://github.com/PracticallyGreen/omniauth-aveda-purepro

## Installation

This gem cannot be used without prior coordination with the Aveda PurePro development team.

Add this line to your Rails application's `Gemfile`:

```ruby
gem 'omniauth-aveda-purepro'
```

And then execute:

```shell
$ bundle
```

Add to `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :aveda_purepro,
    :auth_url         => 'https://avedapurepro.example.com/templates/redirects/company.tmpl',
    :rpc_endpoint_url => 'https://avedapurepro.example.com/jsonrpc.json'
end
```

## Options

* `:auth_url` - URL of the company redirect page on the Aveda PurePro site.
  **Required**.

* `:rpc_endpoint_url` - URL of the Aveda PurePro JSON-RPC API.
  **Required**.

## Authors

Authored by [Rajiv Aaron Manglani](http://www.rajivmanglani.com/).

## License

Copyright (c) 2013 [Practically Green, Inc.](http://www.practicallygreen.com/).
All rights reserved. Released under the MIT license.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
