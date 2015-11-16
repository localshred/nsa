require_relative "../../test_helper"

class ::NSA::StatsdInformantTest < ::MiniTest::Unit::TestCase

  def test_collect_action_controller
    collector = mock
    collector.expects(:responds_to?).with(:collect).returns(true)
    collector.expects(:collect).with("foo")
    ::NSA::StatsdInformant.collect(collector, "foo")
  end

  def test_null_collector
    collector = ::NSA::StatsdInformant::COLLECTOR_TYPES[:skibidy]
    assert_equal(::NSA::Collectors::Null, collector, "not a null collector")
  end

end

