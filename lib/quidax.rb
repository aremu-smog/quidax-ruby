# frozen_string_literal: true

require "faraday"
require_relative "quidax/version"
require_relative "quidax/error.rb"
require_relative "quidax/utils.rb"
require_relative "quidax/modules/api.rb"
require_relative "quidax/objects/base.rb"
require_relative "quidax/objects/user.rb"


module Quidax
  class Quidax
    attr_reader :secret_key
    def initialize(secret_key)
      raise ArgumentError.new("Please pass your secret key") unless secret_key != nil
      @secret_key = secret_key
    end
end
end
