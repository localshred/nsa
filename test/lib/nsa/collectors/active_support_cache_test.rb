require_relative "../../../test_helper"

class ActiveSupportCacheTest < ::Minitest::Test
  def test_collect_cache_delete
    duration = 0.1
    event = {}
    expect_subscriber("cache_delete.active_support", event, duration)

    ::NSA::Collectors::ActiveSupportCache.expects(:statsd_timing).with("cache.delete.duration", in_delta(duration * 1000))
    ::NSA::Collectors::ActiveSupportCache.collect("cache")
  end

  def test_collect_cache_exist?
    duration = 0.1
    event = {}
    expect_subscriber("cache_exist?.active_support", event, duration)

    ::NSA::Collectors::ActiveSupportCache.expects(:statsd_timing).with("cache.exist?.duration", in_delta(duration * 1000))
    ::NSA::Collectors::ActiveSupportCache.collect("cache")
  end

  def test_collect_cache_fetch_hit
    duration = 0.1
    event = {}
    expect_subscriber("cache_fetch_hit.active_support", event, duration)

    ::NSA::Collectors::ActiveSupportCache.expects(:statsd_timing).with("cache.fetch_hit.duration", in_delta(duration * 1000))
    ::NSA::Collectors::ActiveSupportCache.collect("cache")
  end

  def test_collect_cache_generate
    duration = 0.1
    event = {}
    expect_subscriber("cache_generate.active_support", event, duration)

    ::NSA::Collectors::ActiveSupportCache.expects(:statsd_timing).with("cache.generate.duration", in_delta(duration * 1000))
    ::NSA::Collectors::ActiveSupportCache.collect("cache")
  end

  def test_collect_cache_read_hit
    duration = 0.1
    event = { :hit => true }
    expect_subscriber("cache_read.active_support", event, duration)

    ::NSA::Collectors::ActiveSupportCache.expects(:statsd_timing).with("cache.read_hit.duration", in_delta(duration * 1000))
    ::NSA::Collectors::ActiveSupportCache.collect("cache")
  end

  def test_collect_cache_read_miss
    duration = 0.1
    event = { :hit => false }
    expect_subscriber("cache_read.active_support", event, duration)

    ::NSA::Collectors::ActiveSupportCache.expects(:statsd_timing).with("cache.read_miss.duration", in_delta(duration * 1000))
    ::NSA::Collectors::ActiveSupportCache.collect("cache")
  end

  def test_collect_cache_write
    duration = 0.1
    event = {}
    expect_subscriber("cache_write.active_support", event, duration)

    ::NSA::Collectors::ActiveSupportCache.expects(:statsd_timing).with("cache.write.duration", in_delta(duration * 1000))
    ::NSA::Collectors::ActiveSupportCache.collect("cache")
  end

  def test_collect_cache_some_other_key
    duration = 0.1
    event = {}
    expect_subscriber("cache_some_other_key.active_support", event, duration)

    ::NSA::Collectors::ActiveSupportCache.expects(:statsd_timing).with("cache.some_other_key.duration", in_delta(duration * 1000))
    ::NSA::Collectors::ActiveSupportCache.collect("cache")
  end

  private

  def expect_subscriber(event_name, payload, duration = 1)
    finish = ::Time.now
    start = finish - duration

    ::ActiveSupport::Notifications
      .expects(:subscribe)
      .with(/cache_[^.]+.active_support/)
      .yields(event_name, start, finish, ::SecureRandom.hex, payload)
  end

end
