# frozen_string_literal: true

module PgAdvisoryLocking
  class RollbackDummy
    def initialize(&block)
      @block = block
    end

    def rolledback!(*)
      @block.call
      close_transaction
    end

    def close_transaction(*)
    end

    def before_committed!(*)
    end

    def committed!(*)
    end
  end

  class SessionLock < Base
    def exec
      obtained = obtain
      yield

    ensure
      release if obtained
    end

    def exec_if_available
      return unless lock_available?

      begin
        yield
      ensure
        release
      end
    end

    private

    def obtain
      !!@connection.execute("SELECT pg_advisory_lock(#{pg_key})")
    end

    def lock_available?
      @connection.select_value("SELECT pg_try_advisory_lock(#{pg_key})")
    end

    def release
      !!@connection.execute("SELECT pg_advisory_unlock(#{pg_key})")

    rescue ActiveRecord::StatementInvalid => e
      raise unless e.cause.is_a?(PG::InFailedSqlTransaction)

      dummy = RollbackDummy.new do
        @connection.execute("SELECT pg_advisory_unlock(#{pg_key})")
      end

      @connection.add_transaction_record(dummy)
    end
  end
end
