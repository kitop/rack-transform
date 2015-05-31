module Rack
  class Transform
    class Transformer
      REQUEST_NOOP = Proc.new { |env| env }
      RESPONSE_NOOP = Proc.new { |status, header, body| [status, header, body] }

      attr_accessor :request, :response

      def initialize
        @request = REQUEST_NOOP
        @response = RESPONSE_NOOP
        yield self if block_given?
      end
    end
  end
end
