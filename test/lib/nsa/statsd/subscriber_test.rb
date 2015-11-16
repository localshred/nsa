require_relative "../../../test_helper"

class SubscriberTest < ::MiniTest::Unit::TestCase

  InformantTest = Class.new do
    include ::NSA::Statsd::Subscriber
  end

  attr_accessor :informant, :backend

  NAME = "count.statsd"
  START = ::Time.now - 3
  FINISH = ::Time.now - 2
  NOTIFICATION_ID = ::SecureRandom.hex
  KEY = :total_users
  VALUE = 321
  SAMPLE_RATE = 0.8
  BLOCK = -> { 1 }
  PAYLOAD = { :key => KEY, :value => VALUE, :sample_rate => SAMPLE_RATE, :block => BLOCK }

  def setup
    @informant = InformantTest.new
    @backend = mock
  end

  def test_statsd_subscribe
    informant.expects(:__send_event_to_statsd).with(backend, NAME, START, FINISH, NOTIFICATION_ID, PAYLOAD)
    ::ActiveSupport::Notifications.expects(:subscribe).with(/.statsd$/).yields(NAME, START, FINISH, NOTIFICATION_ID, PAYLOAD)
    informant.statsd_subscribe(backend)
  end

  def test_key_value_event_types
    backend.expects(:count).with(KEY, VALUE, SAMPLE_RATE)
    backend.expects(:gauge).with(KEY, VALUE, SAMPLE_RATE)
    backend.expects(:set).with(KEY, VALUE, SAMPLE_RATE)
    backend.expects(:timing).with(KEY, VALUE, SAMPLE_RATE)
    informant.__send_event_to_statsd(backend, "count.statsd", START, FINISH, NOTIFICATION_ID, PAYLOAD)
    informant.__send_event_to_statsd(backend, "gauge.statsd", START, FINISH, NOTIFICATION_ID, PAYLOAD)
    informant.__send_event_to_statsd(backend, "set.statsd", START, FINISH, NOTIFICATION_ID, PAYLOAD)
    informant.__send_event_to_statsd(backend, "timing.statsd", START, FINISH, NOTIFICATION_ID, PAYLOAD)
  end

  def test_key_event_types
    backend.expects(:decrement).with(KEY, SAMPLE_RATE)
    backend.expects(:increment).with(KEY, SAMPLE_RATE)
    backend.expects(:time).with(KEY, SAMPLE_RATE)
    informant.__send_event_to_statsd(backend, "decrement.statsd", START, FINISH, NOTIFICATION_ID, PAYLOAD)
    informant.__send_event_to_statsd(backend, "increment.statsd", START, FINISH, NOTIFICATION_ID, PAYLOAD)
    informant.__send_event_to_statsd(backend, "time.statsd", START, FINISH, NOTIFICATION_ID, PAYLOAD)
  end


end
