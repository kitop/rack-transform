module Rack
  class Transform
    module Transformers
      module Base
        class Request
          CONTENT_TYPE = "CONTENT_TYPE".freeze
          CONTENT_LENGTH = "CONTENT_LENGTH".freeze
          POST_BODY = "rack.input".freeze
          JSON_TYPE = "application/json".freeze

          def self.call(env)
            new(env).process
          end

          attr_reader :env

          def initialize(env)
            @env = env
          end

          def process
            raise NotImplementedError
          end

          private

          def req
            @req ||= Rack::Request.new(env)
          end

          def params
            req.params
          end

          def update_env(path:, query:, method:, body:)
            body = body.is_a?(String) ? body : dump_json(body)
            env.update(
              Rack::PATH_INFO => path,
              Rack::QUERY_STRING => query,
              Rack::REQUEST_METHOD => method,
              CONTENT_TYPE => JSON_TYPE,
              CONTENT_LENGTH => body.bytesize,
              POST_BODY => StringIO.new(body)
            )
          end

          def dump_json(data)
            JSON.dump(data)
          end
        end

        class Response
          CONTENT_LENGTH = "Content-Length".freeze
          CONTENT_TYPE = "Content-Type".freeze
          JSON_TYPE = "application/json".freeze

          def self.call(status, header, body)
            new(status, header, body).process
          end

          attr_reader :status, :header, :body

          def initialize(status, header, body)
            @status = status
            @header = header.merge CONTENT_TYPE => JSON_TYPE
            @body = body
          end

          def process
            raise NotImplementedError
          end

          private

          def respond_with(body, status: 200, header: @header)
            formatted_body = body.is_a?(String) ? body : dump_json(body)

            header[CONTENT_LENGTH] = formatted_body.bytesize.to_s

            [status, header, [formatted_body]]
          end

          def parsed_body
            @parsed_body ||= body.empty? ? [] : load_json(body.first)
          end

          def dump_json(data)
            JSON.dump(data)
          end

          def load_json(data)
            JSON.load(data)
          end
        end
      end
    end
  end
end
