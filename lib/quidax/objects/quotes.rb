# frozen_string_literal: true

# Object for quotes
class QuidaxQuotes < QuidaxBaseObject
  def get(market:, unit:, kind:, volume:)
    QuidaxQuotes.get(q_object: @quidax, market: market, unit: unit, kind: kind, volume: volume)
  end

  def self.get(q_object:, market:, unit:, kind:, volume:)
    raise ArgumentError, "kind should be ask or bid" unless %w[ask bid].include?(kind)

    path = API::QUOTE_PATH
    params = {
      market: market,
      unit: unit,
      kind: kind,
      volume: volume
    }

    get_request(q_object, path, params)
  end
end
