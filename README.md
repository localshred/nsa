# NSA (National Statsd Agency)

Listen to your Rails ActiveSupport::Notifications and deliver to a Statsd backend.
Support for writing your own custom collectors.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "nsa"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nsa

## Usage

NSA comes packaged with collectors for ActionController, ActiveRecord, ActiveSupport Caching,
and Sidekiq.

To use this gem, simply get a reference to a statsd backend, then indicate which
collectors you'd like to run. Each `collect` method specifies a Collector to use
and the additional key namespace.

```ruby
$statsd = ::Statsd.new(ENV["STATSD_HOST"], ENV["STATSD_PORT"])
application_name = ::Rails.application.class.parent_name.underscore
application_env = ENV["PLATFORM_ENV"] || ::Rails.env
$statsd.namespace = [ application_name, application_env ].join(".")

::NSA.inform_statsd($statsd) do |informant|
  # Load :action_controller collector with a key prefix of :web
  informant.collect(:action_controller, :web)
  informant.collect(:active_record, :db)
  informant.collect(:cache, :cache)
  informant.collect(:sidekiq, :sidekiq)
end
```

## Built-in Collectors

### `:action_controller`

Listens to: `process_action.action_controller

Metrics recorded:

+ Timing: `{ns}.{prefix}.{controller}.{action}.{format}.total_duration`
+ Timing: `{ns}.{prefix}.{controller}.{action}.{format}.db_time`
+ Timing: `{ns}.{prefix}.{controller}.{action}.{format}.view_time`
+ Increment: `{ns}.{prefix}.{controller}.{action}.{format}.status.{status_code}`

### `:active_record`

Listens to: `sql.active_record`

Metrics recorded:

+ Timing: `{ns}.{prefix}.tables.{table_name}.queries.delete.duration`
+ Timing: `{ns}.{prefix}.tables.{table_name}.queries.insert.duration`
+ Timing: `{ns}.{prefix}.tables.{table_name}.queries.select.duration`
+ Timing: `{ns}.{prefix}.tables.{table_name}.queries.update.duration`

### `:active_support_cache`

Listens to: `cache_*.active_suppport`

Metrics recorded:

+ Timing: `{ns}.{prefix}.delete.duration`
+ Timing: `{ns}.{prefix}.exist?.duration`
+ Timing: `{ns}.{prefix}.fetch_hit.duration`
+ Timing: `{ns}.{prefix}.generate.duration`
+ Timing: `{ns}.{prefix}.read_hit.duration`
+ Timing: `{ns}.{prefix}.read_miss.duration`
+ Timing: `{ns}.{prefix}.read_miss.duration`

### `:sidekiq`

Listens to: Sidekiq middleware, run before each job that is processed

Metrics recorded:

+ Time: `{ns}.{prefix}.{WorkerName}.processing_time`
+ Increment: `{ns}.{prefix}.{WorkerName}.success`
+ Increment: `{ns}.{prefix}.{WorkerName}.failure`
+ Gauge: `{ns}.{prefix}.queues.{queue_name}.enqueued`
+ Gauge: `{ns}.{prefix}.queues.{queue_name}.latency`
+ Gauge: `{ns}.{prefix}.dead_size`
+ Gauge: `{ns}.{prefix}.enqueued`
+ Gauge: `{ns}.{prefix}.failed`
+ Gauge: `{ns}.{prefix}.processed`
+ Gauge: `{ns}.{prefix}.processes_size`
+ Gauge: `{ns}.{prefix}.retry_size`
+ Gauge: `{ns}.{prefix}.scheduled_size`
+ Gauge: `{ns}.{prefix}.workers_size`

## Writing your own collector

Writing your own collector is very simple. To take advantage of the keyspace handling you must:

1. Create an object/module which responds to `collect`, taking the `key_prefix` as its only argument.
2. Include or extend your class/module with `NSA::Statsd::Publisher`.

For example:

```ruby
module UsersCollector
  extend ::NSA::Statsd::Publisher

  def self.collect(key_prefix)
    loop do
      statsd_gauge("count", ::User.count)
      sleep 10 # don't do this, obvi
    end
  end
end
```

Then let the informant know about it:

```ruby
# $statsd =
NSA.inform_statsd($statsd) do |informant|
  # ...
  informant.collect(UserCollector, :users)
end
```

The `NSA::Statsd::Publisher` module exposes the following methods:

+ `statsd_count(key, value = 1, sample_rate = nil)`
+ `statsd_decrement(key, sample_rate = nil)`
+ `statsd_gauge(key, value = 1, sample_rate = nil)`
+ `statsd_increment(key, sample_rate = nil)`
+ `statsd_set(key, value = 1, sample_rate = nil)`
+ `statsd_time(key, sample_rate = nil, &block)`
+ `statsd_timing(key, value = 1, sample_rate = nil)`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/localshred/nsa.

