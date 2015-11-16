require_relative "../../../test_helper"

class PublisherTest < ::Minitest::Test

  CollectorTest = Class.new do
    include ::NSA::Statsd::Publisher
  end

  attr_accessor :collector

  def setup
    @collector = CollectorTest.new
  end

  def test_count
    collector.expects(:__statsd_publish).with(:count, :foo, 5, 0.5)
    collector.expects(:__statsd_publish).with(:count, :bar, 15, nil)
    collector.expects(:__statsd_publish).with(:count, :baz, 1, nil)
    collector.statsd_count(:foo, 5, 0.5)
    collector.statsd_count(:bar, 15)
    collector.statsd_count(:baz)
  end

  def test_decrement
    collector.expects(:__statsd_publish).with(:decrement, :foo, 1, 0.5)
    collector.expects(:__statsd_publish).with(:decrement, :bar, 1, nil)
    collector.statsd_decrement(:foo, 0.5)
    collector.statsd_decrement(:bar)
  end

  def test_gauge
    collector.expects(:__statsd_publish).with(:gauge, :foo, 5, 0.5)
    collector.expects(:__statsd_publish).with(:gauge, :bar, 15, nil)
    collector.expects(:__statsd_publish).with(:gauge, :baz, 1, nil)
    collector.statsd_gauge(:foo, 5, 0.5)
    collector.statsd_gauge(:bar, 15)
    collector.statsd_gauge(:baz)
  end

  def test_increment
    collector.expects(:__statsd_publish).with(:increment, :foo, 1, 0.5)
    collector.expects(:__statsd_publish).with(:increment, :bar, 1, nil)
    collector.statsd_increment(:foo, 0.5)
    collector.statsd_increment(:bar)
  end

  def test_set
    collector.expects(:__statsd_publish).with(:set, :foo, 5, 0.5)
    collector.expects(:__statsd_publish).with(:set, :bar, 15, nil)
    collector.expects(:__statsd_publish).with(:set, :baz, 1, nil)
    collector.statsd_set(:foo, 5, 0.5)
    collector.statsd_set(:bar, 15)
    collector.statsd_set(:baz)
  end

  def test_time
    collector.expects(:__statsd_publish).with(:time, :foo, nil, 0.5)
    collector.expects(:__statsd_publish).with(:time, :bar, nil, nil)
    collector.statsd_time(:foo, 0.5)
    collector.statsd_time(:bar)
  end

  def test_timing
    collector.expects(:__statsd_publish).with(:timing, :foo, 5, 0.5)
    collector.expects(:__statsd_publish).with(:timing, :bar, 15, nil)
    collector.expects(:__statsd_publish).with(:timing, :baz, 1, nil)
    collector.statsd_timing(:foo, 5, 0.5)
    collector.statsd_timing(:bar, 15)
    collector.statsd_timing(:baz)
  end

  def test___statsd_publish
    ::ActiveSupport::Notifications.expects(:instrument).with("count.statsd", { :key => :foo })
    collector.__statsd_publish(:count, :foo)
  end

  def test___statsd_publish_with_value
    ::ActiveSupport::Notifications.expects(:instrument).with("count.statsd", { :key => :foo, :value => 32 })
    collector.__statsd_publish(:count, :foo, 32)
  end

  def test___statsd_publish_with_sample_rate
    ::ActiveSupport::Notifications.expects(:instrument).with("count.statsd", { :key => :foo, :sample_rate => 0.5 })
    ::ActiveSupport::Notifications.expects(:instrument).with("count.statsd", { :key => :bar, :value => 23, :sample_rate => 0.5 })
    collector.__statsd_publish(:count, :foo, nil, 0.5)
    collector.__statsd_publish(:count, :bar, 23, 0.5)
  end

  def test___statsd_publish_with_block
    block = -> { 1 }
    ::ActiveSupport::Notifications.expects(:instrument).with("count.statsd", { :key => :foo, :sample_rate => 0.5, :block => block })
    ::ActiveSupport::Notifications.expects(:instrument).with("count.statsd", { :key => :bar, :value => 87, :sample_rate => 0.5, :block => block })
    ::ActiveSupport::Notifications.expects(:instrument).with("count.statsd", { :key => :baz, :block => block })
    collector.__statsd_publish(:count, :foo, nil, 0.5, &block)
    collector.__statsd_publish(:count, :bar, 87, 0.5, &block)
    collector.__statsd_publish(:count, :baz, &block)
  end

end
