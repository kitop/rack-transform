require_relative "../helper"

RSpec.describe Rack::Transform do
  context "request" do
    it "transforms a request" do
      stack = Rack::Builder.new do
        use Rack::Transform do |map|
          map.on("foo") do |transformer|
            transformer.request = proc do |env|
              env[Rack::REQUEST_METHOD] = "POST"
              env
            end
          end
        end

        run Proc.new { |env|
          [200, {}, ["method: #{env[Rack::REQUEST_METHOD]}"]]
        }
      end

      request = Rack::MockRequest.new(stack)

      response = request.get("?type=foo")

      expect(response.body).to eq "method: POST"
    end
  end

  context "response" do
    it "transforms a response" do
      stack = Rack::Builder.new do
        use Rack::Transform do |map|
          map.on("bar") do |transformer|
            transformer.response = proc do |status, header, body|
              new_body = ["response: #{body.join("")}"]
              [status, header, new_body]
            end
          end
        end

        run Proc.new { |env|
          [200, {}, ["lorem ipsum"]]
        }
      end

      request = Rack::MockRequest.new(stack)

      response = request.get("?type=bar")

      expect(response.body).to eq "response: lorem ipsum"
    end
  end
end
