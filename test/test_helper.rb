$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))
require "nsa"

require "byebug"
require "minitest/pride"
require "minitest/unit"
require "mocha/minitest"

require "minitest/autorun"

module Mocha::ParameterMatchers
  class InDelta < Mocha::ParameterMatchers::Base
    def initialize(value, delta=0.001)
      @value, @delta = value, delta
      @range = (-@delta...@delta)
    end

    def matches?(available_parameters)
      parameter = available_parameters.shift
      @range.cover?(parameter - @value)
    end

    def mocha_inspect
      "in_delta(#{@value.mocha_inspect}, #{@delta.mocha_inspect})"
    end
  end

  def in_delta(*args)
    InDelta.new(*args)
  end
end
