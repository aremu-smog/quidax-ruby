# frozen_string_literal: true

# Object for quotes
class QuidaxQuote < QuidaxBaseObject
  def get(query:)
    QuidaxQuote.get(q_object: @quidax, query: query)
  end

  def self.get(q_object:, query:)
    query.stringify_keys!
    Utils.check_missing_keys(required_keys: %w[market unit kind volume], keys: query.keys, field: "query")
    Utils.validate_value_in_array(array: %w[ask bid], value: query["kind"], field: 'query["kind"]')

    path = API::QUOTE_PATH

    get_request(q_object, path, query)
  end
end
