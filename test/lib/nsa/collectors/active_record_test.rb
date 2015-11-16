require_relative "../../../test_helper"

class ActiveRecordTest < ::Minitest::Test

  def test_collect_delete_query
    duration = 0.1
    event = { :sql => %q{DELETE FROM "users" WHERE "users".id = 1} }
    expect_subscriber(event, duration)

    ::NSA::Collectors::ActiveRecord.expects(:statsd_timing).with("db.tables.users.queries.delete.duration", duration * 1000)
    ::NSA::Collectors::ActiveRecord.collect("db")
  end

  def test_collect_insert_query
    duration = 0.2
    event = { :sql => %q{INSERT INTO "users" ("id", "name") VALUES (1, 'Bob')} }
    expect_subscriber(event, duration)

    ::NSA::Collectors::ActiveRecord.expects(:statsd_timing).with("db.tables.users.queries.insert.duration", duration * 1000)
    ::NSA::Collectors::ActiveRecord.collect("db")
  end

  def test_collect_select_query
    duration = 0.3
    event = { :sql => %q{SELECT "users".id, "users".name FROM "users"} }
    expect_subscriber(event, duration)

    ::NSA::Collectors::ActiveRecord.expects(:statsd_timing).with("db.tables.users.queries.select.duration", duration * 1000)
    ::NSA::Collectors::ActiveRecord.collect("db")
  end

  def test_collect_update_query
    duration = 0.4
    event = { :sql => %q{UPDATE "users" SET "users".name = 'Joe' WHERE "users".id = 1} }
    expect_subscriber(event, duration)

    ::NSA::Collectors::ActiveRecord.expects(:statsd_timing).with("db.tables.users.queries.update.duration", duration * 1000)
    ::NSA::Collectors::ActiveRecord.collect("db")
  end

  private

  def expect_subscriber(payload, duration = 1)
    finish = ::Time.now
    start = finish - duration

    ::ActiveSupport::Notifications
      .expects(:subscribe)
      .with("sql.active_record")
      .yields("sql.active_record", start, finish, ::SecureRandom.hex, payload)
  end

end
