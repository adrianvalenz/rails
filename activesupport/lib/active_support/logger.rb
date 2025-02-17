# frozen_string_literal: true

require "active_support/logger_silence"
require "active_support/logger_thread_safe_level"
require "logger"

module ActiveSupport
  class Logger < ::Logger
    include LoggerSilence

    # Returns true if the logger destination matches one of the sources
    #
    #   logger = Logger.new(STDOUT)
    #   ActiveSupport::Logger.logger_outputs_to?(logger, STDOUT)
    #   # => true
    def self.logger_outputs_to?(logger, *sources)
      logdev = logger.instance_variable_get(:@logdev)
      logger_source = logdev.dev if logdev.respond_to?(:dev)
      sources.any? { |source| source == logger_source }
    end

    def initialize(*args, **kwargs)
      super
      @formatter ||= SimpleFormatter.new
    end

    # Simple formatter which only displays the message.
    class SimpleFormatter < ::Logger::Formatter
      # This method is invoked when a log event occurs
      def call(severity, timestamp, progname, msg)
        "#{String === msg ? msg : msg.inspect}\n"
      end
    end
  end
end
