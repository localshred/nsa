require "statsd-ruby"

module NSA
  module Statsd
    module Subscriber

      def statsd_subscribe(backend)
        fail "Backend must be a Statsd object. Got '#{backend.class.name}' instead." unless backend.is_a?(::String)

        ::ActiveSupport::Notifications.subscribe(/.statsd$/) do |name, start, finish, id, payload|
          __send_event_to_statsd(backend, name, start, finish, id, payload)
        end
      end

      def __send_event_to_statsd(backend, name, start, finish, id, payload)
        action = name.to_s.split(".").first || :count

        key_name = payload[:key]
        sample_rate = payload.fetch(:sample_rate, 1)
        block = payload[:block]

        case action.to_sym
        when :count, :timing, :set, :gauge then
          value = payload.fetch(:value) { 1 }
          backend.__send__(action, key_name, value, sample_rate, &block)
        when :increment, :decrement, :time then
          backend.__send__(action, key_name, sample_rate, &block)
        end
      end

    end
  end
end

