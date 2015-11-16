require "nsa/statsd/publisher"

module NSA
  module Collectors
    module ActiveRecord
      extend ::NSA::Statsd::Publisher

      DELETE_SQL_REGEX = /^DELETE.+FROM\s+"([^"]+)"/
      INSERT_SQL_REGEX = /^INSERT INTO\s+"([^"]+)"/
      SELECT_SQL_REGEX = /^SELECT.+FROM\s+"([^"]+)"/
      UPDATE_SQL_REGEX = /^UPDATE\s+"([^"]+)"/

      def self.collect(key_prefix)
        ::ActiveSupport::Notifications.subscribe("sql.active_record") do |_, start, finish, _id, payload|
          query_type, table_name = case payload[:sql]
                                   when DELETE_SQL_REGEX then [ :delete, $1 ]
                                   when INSERT_SQL_REGEX then [ :insert, $1 ]
                                   when SELECT_SQL_REGEX then [ :select, $1 ]
                                   when UPDATE_SQL_REGEX then [ :update, $1 ]
                                   else nil
                                   end

          unless query_type.nil?
            stat_name = "#{key_prefix}.tables.#{table_name}.queries.#{query_type}.duration"
            duration_ms = (finish - start) * 1000
            statsd_timing(stat_name, duration_ms)
          end
        end

      end
    end
  end
end

