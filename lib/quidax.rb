# frozen_string_literal: true

require "faraday"
require_relative "quidax/version"
require_relative "quidax/error"
require_relative "quidax/utils"
require_relative "quidax/modules/api"
require_relative "quidax/objects/base"
require_relative "quidax/objects/user"
require_relative "quidax/objects/wallet"

module Quidax
  # Intialize a quidax config object
  class Quidax
    attr_reader :secret_key

    def initialize(secret_key)
      raise ArgumentError, "Please pass your secret key" if secret_key.nil?

      @secret_key = secret_key
    end
  end
end
