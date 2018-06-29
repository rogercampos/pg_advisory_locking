# frozen_string_literal: true

module PgAdvisoryLocking
  class TransactionLock < Base
    def exec
      obtain
      yield
    end

    def exec_if_available
      yield if lock_available?
    end

    def obtain
      !!@connection.execute("SELECT pg_advisory_xact_lock(#{pg_key})")
    end

    def lock_available?
      @connection.select_value("SELECT pg_try_advisory_xact_lock(#{pg_key})")
    end
  end
end
