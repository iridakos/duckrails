require 'rspec/matchers'

module RSpec
  module Matchers
    module ControllerFilters
      # Error signaling that a matcher fails.
      class FilterFailureError < StandardError;
      end

      ROUTING_ERROR_CLASS = ActionController::RoutingError

      class << self
        # Resolves the error message to show for a failing test.
        #
        # If neither a routing nor an unexpected error has occurred, the message to be displayed describes the failed expectation.
        def resolve_failure_message(scope, actual, expectations, routing_error, unexpected_error, negated)
          return unexpected_failure_message_for scope, actual, expectations, unexpected_error if unexpected_error.present?
          return routing_failure_message_for scope, actual, expectations, routing_error if routing_error.present?
          failure_message_for scope, actual, expectations, negated
        end

        protected

        def failure_message_for(scope, actual, expectations, negated)
          filter = expectations[0]
          options = expectations[1]
          action = options[:on]
          via = options[:via]
          params = options[:with]

          "Expected #{actual.class} #{negated ? 'not ' : ''}to execute filter '#{filter}' #{scope.to_s} action '#{action}' (request made via #{via} with params '#{params}') but it did#{negated ? '' : 'n\'t'}."
        end

        def routing_failure_message_for(scope, actual, expectations, routing_error)
          filter = expectations[0]
          options = expectations[1]
          action = options[:on]
          via = options[:via]
          params = options[:with]

          message = "Routing error while trying to check if #{actual.class} executes '#{filter}' #{scope.to_s} action '#{action}' (request made via #{via} with params '#{params}').\n"
          message << "Check your params (ex you might need to include an id).\n"
          message << "Routing error description: #{routing_error}"
        end

        def unexpected_failure_message_for(scope, actual, expectations, unexpected_error)
          filter = expectations[0]
          options = expectations[1]
          action = options[:on]
          via = options[:via]
          params = options[:with]

          message = "Unexpected error while trying to check if #{actual.class} executes '#{filter}' #{scope.to_s} action '#{action}' (request made via #{via} with params '#{params}').\n"
          message << "Error description: #{unexpected_error}"
        end
      end
    end
  end
end

RSpec::Matchers.define :execute_before_filter do |filter_name, options = {}|
  match do |controller|
    execute_match(filter_name, options, false)
  end

  match_when_negated do |controller|
    !execute_match(filter_name, options, true)
  end

  def execute_match(filter_name, options, negated)
    allow(controller).to receive(filter_name).and_wrap_original do |&block|
      @filter_executed = block.nil?
    end

    allow(controller).to receive(options[:on]) do
      raise RSpec::Matchers::ControllerFilters::FilterFailureError if !@filter_executed || @action_executed
      @action_executed = true
      controller.render plain: 'success'
    end

    begin
      send(options[:via] || :get, options[:on], params: options[:with])
      @filter_executed
    rescue RSpec::Matchers::ControllerFilters::FilterFailureError
      false
    rescue RSpec::Matchers::ControllerFilters::ROUTING_ERROR_CLASS => e
      @routing_error = e.message
      negated
    rescue => e
      @unexpected_error = e.message
      negated
    end
  end

  failure_message do |actual|
    RSpec::Matchers::ControllerFilters.resolve_failure_message :before, actual, expected, @routing_error, @unexpected_error, false
  end

  failure_message_when_negated do |actual|
    RSpec::Matchers::ControllerFilters.resolve_failure_message :before, actual, expected, @routing_error, @unexpected_error, true
  end
end
RSpec::Matchers.alias_matcher :execute_before_action, :execute_before_filter

RSpec::Matchers.define :execute_after_filter do |filter_name, options = {}|
  match do |controller|
    execute_match(filter_name, options, false)
  end

  match_when_negated do |controller|
    !execute_match(filter_name, options, true)
  end

  def execute_match(filter_name, options, negated)
    allow(controller).to receive(filter_name) {
      raise RSpec::Matchers::ControllerFilters::FilterFailureError unless @action_executed
      @filter_executed = true
    }

    allow(controller).to receive(options[:on]) {
      @action_executed = true
      controller.render plain: 'success'
    }

    result = begin
      send(options[:via] || :get, options[:on], params: options[:with])
      @action_executed && @filter_executed
    rescue RSpec::Matchers::ControllerFilters::FilterFailureError
      false
    rescue RSpec::Matchers::ControllerFilters::ROUTING_ERROR_CLASS => e
      @routing_error = e.message
      negated
    rescue => e
      @unexpected_error = e.message
      negated
    end

    result
  end

  failure_message do |actual|
    RSpec::Matchers::ControllerFilters.resolve_failure_message :after, actual, expected, @routing_error, @unexpected_error, false
  end

  failure_message_when_negated do |actual|
    RSpec::Matchers::ControllerFilters.resolve_failure_message :after, actual, expected, @routing_error, @unexpected_error, true
  end
end
RSpec::Matchers.alias_matcher :execute_after_action, :execute_after_filter

RSpec::Matchers.define :execute_around_filter do |filter_name, options = {}|
  match do |controller|
    execute_match(filter_name, options, false)
  end

  match_when_negated do |controller|
    !execute_match(filter_name, options, true)
  end

  def execute_match(filter_name, options, negated)
    allow(controller).to receive(options[:on]) {
      if !@filter_executed || @action_executed
        raise RSpec::Matchers::ControllerFilters::FilterFailureError
      else
        @action_executed = true
      end
    }

    allow(controller).to receive(filter_name) {
      @filter_executed = true
      controller.send(options[:on])
    }

    send(options[:via] || :get, options[:on], params: options[:with])
    @filter_executed && @action_executed
  rescue RSpec::Matchers::ControllerFilters::FilterFailureError
    false
  rescue RSpec::Matchers::ControllerFilters::ROUTING_ERROR_CLASS => e
    @routing_error = e.message
    negated
  rescue => e
    @unexpected_error = e.message
    negated
  end

  failure_message do |actual|
    RSpec::Matchers::ControllerFilters.resolve_failure_message :around, actual, expected, @routing_error, @unexpected_error, false
  end

  failure_message_when_negated do |actual|
    RSpec::Matchers::ControllerFilters.resolve_failure_message :around, actual, expected, @routing_error, @unexpected_error, true
  end
end
RSpec::Matchers.alias_matcher :execute_around_action, :execute_around_filter
