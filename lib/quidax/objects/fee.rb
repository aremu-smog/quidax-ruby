# frozen_string_literal: true

# Fees object
class QuidaxFee < QuidaxBaseObject
  def get(query:)
    QuidaxFee.get(q_object: @quidax, query: query)
  end

  def self.get(q_object:, query:)
    query.stringify_keys!

    Utils.check_missing_keys(required_keys: %w[currency network], keys: query.keys, field: "query")
    path = API::FEE_PATH

    get_request(q_object, path, query)
  end
end
