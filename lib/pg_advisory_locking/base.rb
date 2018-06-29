# frozen_string_literal: true

module PgAdvisoryLocking
  class Base
    def initialize(key, opts = {})
      @key = case key
               when String
                 key
               when Array
                 key.map(&:to_s).join('/')
               else
                 raise "Unsupported type of key #{key.class}"
             end
      @connection = opts.fetch(:connection, ActiveRecord::Base.connection)
    end

    def pg_key
      @pg_key ||= begin
        bigint_bytes = 8
        pg_bigint_range = 2**(bigint_bytes * 8)
        hex_digits = 2 * bigint_bytes

        Digest::SHA1.hexdigest(@key)[0..hex_digits - 1].to_i(16) - pg_bigint_range / 2
      end
    end
  end
end
