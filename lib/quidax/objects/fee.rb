# frozen_string_literal: true

# Fees object
class QuidaxFee < QuidaxBaseObject
  def get(currency:, network:)
    QuidaxFee.get(q_object: @quidax, currency: currency, network: network)
  end

  def self.get(q_object:, currency:, network:)
    path = API::FEE_PATH
    query = {
      currency: currency,
      network: network
    }

    get_request(q_object, path, query)
  end
end
