require_relative "../../../test_helper"

class ActionControllerTest < ::Minitest::Test

  def test_collect
    duration = 0.7
    event = { :controller => "UsersController",
              :action => :index,
              :format => :html,
              :status => 200,
              :db_runtime => 200,
              :view_runtime => 100 }
    expect_subscriber(event, duration)

    ::NSA::Collectors::ActionController.expects(:statsd_timing).with("web.UsersController.index.html.total_duration", duration * 1000)
    ::NSA::Collectors::ActionController.expects(:statsd_timing).with("web.UsersController.index.html.db_time", event[:db_runtime])
    ::NSA::Collectors::ActionController.expects(:statsd_timing).with("web.UsersController.index.html.view_time", event[:view_runtime])
    ::NSA::Collectors::ActionController.expects(:statsd_increment).with("web.UsersController.index.html.status.#{event[:status]}")
    ::NSA::Collectors::ActionController.collect("web")
  end

  def test_collect_nil_format
    duration = 0.7
    event = { :controller => "UsersController",
              :action => :index,
              :format => nil,
              :status => 200,
              :db_runtime => 200,
              :view_runtime => 100 }
    expect_subscriber(event, duration)

    ::NSA::Collectors::ActionController.expects(:statsd_timing).with("web.UsersController.index.all.total_duration", duration * 1000)
    ::NSA::Collectors::ActionController.expects(:statsd_timing).with("web.UsersController.index.all.db_time", event[:db_runtime])
    ::NSA::Collectors::ActionController.expects(:statsd_timing).with("web.UsersController.index.all.view_time", event[:view_runtime])
    ::NSA::Collectors::ActionController.expects(:statsd_increment).with("web.UsersController.index.all.status.#{event[:status]}")
    ::NSA::Collectors::ActionController.collect("web")
  end

  def test_collect_splat_format
    duration = 0.7
    event = { :controller => "UsersController",
              :action => :index,
              :format => "*/*",
              :status => 200,
              :db_runtime => 200,
              :view_runtime => 100 }
    expect_subscriber(event, duration)

    ::NSA::Collectors::ActionController.expects(:statsd_timing).with("web.UsersController.index.all.total_duration", duration * 1000)
    ::NSA::Collectors::ActionController.expects(:statsd_timing).with("web.UsersController.index.all.db_time", event[:db_runtime])
    ::NSA::Collectors::ActionController.expects(:statsd_timing).with("web.UsersController.index.all.view_time", event[:view_runtime])
    ::NSA::Collectors::ActionController.expects(:statsd_increment).with("web.UsersController.index.all.status.#{event[:status]}")
    ::NSA::Collectors::ActionController.collect("web")
  end

  private

  def expect_subscriber(payload, duration = 1)
    finish = ::Time.now
    start = finish - duration

    ::ActiveSupport::Notifications
      .expects(:subscribe)
      .with(/process_action.action_controller/)
      .yields("process_action.action_controller", start, finish, ::SecureRandom.hex, payload)
  end

end
