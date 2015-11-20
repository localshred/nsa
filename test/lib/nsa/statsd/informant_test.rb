require_relative "../../../test_helper"

class ::NSA::Statsd::InformantTest < ::Minitest::Test

  def test_collect_action_controller
    collector = mock
    collector.expects(:respond_to?).with(:collect).returns(true)
    collector.expects(:collect).with("foo")
    ::NSA::Statsd::Informant.collect(collector, "foo")
  end

  def test_null_collector
    collector = ::NSA::Statsd::Informant::COLLECTOR_TYPES[:skibidy]
    assert_equal(::NSA::Collectors::Null, collector, "not a null collector")
  end

end

