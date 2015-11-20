require "concurrent"

module NSA
  module Statsd
    module AsyncPublisher
      include ::NSA::Statsd::Publisher

      def async_statsd_count(key, sample_rate = nil, &block)
        ::Concurrent::Promise.execute(&block).then do |value|
          statsd_count(key, value, sample_rate)
        end
      end

      def async_statsd_gauge(key, sample_rate = nil, &block)
        ::Concurrent::Promise.execute(&block).then do |value|
          statsd_gauge(key, value, sample_rate)
        end
      end

      def async_statsd_set(key, sample_rate = nil, &block)
        ::Concurrent::Promise.execute(&block).then do |value|
          statsd_set(key, value, sample_rate)
        end
      end

      def async_statsd_time(key, sample_rate = nil, &block)
        ::Concurrent::Future.execute do
          statsd_time(key, sample_rate, &block)
        end
      end

      def async_statsd_timing(key, sample_rate = nil, &block)
        ::Concurrent::Promise.execute(&block).then do |value|
          statsd_timing(key, value, sample_rate)
        end
      end

    end
  end
end
