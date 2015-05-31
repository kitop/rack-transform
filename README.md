# Rack::Transform

`Rack::Transform` is a middleware that attemps to make a compatibility layer
between two different request/responses that should hit the same endpoint.

The need arouse when migrating an API from PHP to Ruby, where the URLs were
different and the response body used to have more metadata that was moved to
headers.

[![Build Status](https://travis-ci.org/kitop/rack-transform.svg)](https://travis-ci.org/kitop/rack-transform)
[![Code Climate](https://codeclimate.com/github/kitop/rack-transform/badges/gpa.svg)](https://codeclimate.com/github/kitop/rack-transform)

---

## Usage

```ruby
use Rack::Transform do |map|
  map.on "playlist-get-cues" do |transformer|
    transformer.request = proc do |env|
      ...
    end
    transformer.response = proc do |status, header, body|
      ...
    end
  end

  map.on "search" do |transformer|
    ...
  end
  ...
end
```

`map.on` will receive a string that should match the `type` parameter from the
URL and then a block to set the request and response transformers. For more
information, see `Rack::Transform::Transformer`

## Rack::Transform::Transformer

`Rack:Transform::Transformer` intent is to transform rack requests and/or
responses into a different format.
It can manipulate the request, the response, or both.

Usage:
```ruby
Transformer.new do |transformer|
  transformer.request = proc do |env|
    ...
  end
  transformer.response = proc do |status, header, body|
    ...
  end
end
```

`resquest` and `response` methods should receinve and object that responds to
`call`, it can be a proc # or and object. And they will receive an `env`
object and `status`, `header`, # `body` tuple accordingly. Should return the
same modified as needed.

## Contributing

See the [contributing guide](./CONTRIBUTING.md).

