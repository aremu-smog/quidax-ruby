# frozen_string_literal: true

require "faraday"
require_relative "quidax/version"
require_relative "quidax/error"
require_relative "quidax/utils"
require_relative "quidax/modules/api"
require_relative "quidax/objects/base"
require_relative "quidax/objects/user"
require_relative "quidax/objects/wallet"
require_relative "quidax/objects/withdrawal"
require_relative "quidax/objects/markets"
require_relative "quidax/objects/quote"
require_relative "quidax/objects/fee"
require_relative "quidax/objects/trade"
require_relative "quidax/objects/deposit"
require_relative "quidax/objects/beneficiary"
require_relative "quidax/objects/order"
require_relative "quidax/objects/instant_order"

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
