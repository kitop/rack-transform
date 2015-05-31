require_relative "../../helper"

RSpec.describe Rack::Transform::Transformer do
  let(:formatter) { Rack::Transform::Transformer.new }

  describe "#request" do
    it "defaults to noop" do
      result = formatter.request.call("foo")
      expect(result).to eq "foo"
    end

    it "can assign a block" do
      formatter.request = proc do |env|
        "new env"
      end

      expect(formatter.request.call(1)).to eq "new env"
    end
  end

  describe "#response" do
    it "defaults to noop" do
      result = formatter.response.call("foo", "bar", "baz")
      expect(result).to eq ["foo", "bar", "baz"]
    end

    it "can assign a block" do
      formatter.response = proc do |status, header, body|
        ["new status", "new header", "new body"]
      end

      expect(formatter.response.call(1, 2, 3)).to eq ["new status", "new header", "new body"]
    end
  end
end
