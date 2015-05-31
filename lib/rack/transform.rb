require "rack/transform/transformer"

module Rack
  class Transform
    def initialize(app)
      @app = app
      @transformers = {}
      yield self if block_given?
    end

    def call(env)
      if transformer = request_transformer(env)
        env = transformer.request.call(env)
        status, header, body = @app.call(env)
        transformer.response.call(status, header, body)
      else
        @app.call(env)
      end
    end

    def on(type, &block)
      @transformers[type] ||= Transformer.new(&block)
    end

    private

    def request_transformer(env)
      if env[Rack::REQUEST_METHOD] == Rack::GET
        req = Rack::Request.new(env)
        @transformers[req.params["type"]]
      end
    end
  end
end
