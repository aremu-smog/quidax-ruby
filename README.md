# Quidax

![RSpec Test status](https://github.com/aremu-smog/quidax-ruby/actions/workflows/rspec.yml/badge.svg)

A ruby gem for easy integration of [Quidax](https://docs.quidax.com/docs/getting-started). Please kindly see the [docs](https://docs.quidax.com/docs/getting-started) to get a sense of how the API behaves

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quidax'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install quidax

## Usage

### Instantiate a Quidax Object

To use the SDK, you need to instantiate a quidax object with a secret key

```
secret_key = ENV["QUIDAX_SECRET_KEY"]

quidax_object = Quidax.new(secret_key)
```

### Using an object

See the [table](#quidax-objects) below for a list of available objects.
Kindly note that all objects and methods accepts parameters via named keywords.
There are two ways to use an object:

#### 1. Accessing methods after initializing object instance

In this case you need to pass your `quidax_object` once to the object instance, and you will now be able to access methods on the class. The keyword is `q_object`

```
markets = QuidaxMarkets(q_object: quidax_object)

all_market_tickers = markets.get_all_tickers
```

#### 2. Accessing methods directly from the object

In this case you need to pass `quidax_object` to the method you directly calling, the `keyword` is `q_object`

```
all_market_tickers = QuidaxMarket.get_all_tickers(q_object: quidax_object)
```

> Like you may suspect, the parameters that each method differs, please kindly see the [docs](https://docs.quidax.com/docs/getting-started) to know the expected parameters, `query:` is used to get requests with a payload, while `body:` is used for `post`/`put` requests with a payload

## Quidax Objects

| Object             | Methods                                                                                                                                                                                 |
| :----------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| QuidaxBeneficiary  | get_all <br/> create <br/> get_account <br/> edit_account                                                                                                                               |
| QuidaxDeposits     | by_user <br /> get_a_deposit <br/> by_sub_users                                                                                                                                         |
| QuidaxInstantOrder | get_all <br /> by_sub_users <br/> get_detail <br/> buy_crypto_from_fiat <br/> sell_crypto_to_fiat <br/> confirm <br/> requote                                                           |
| QuidaxMarkets      | get_all <br/> get_all_tickers <br/> get_ticker <br/> get_k_line <br /> get_k_line_with_pending_trades <br/> get_orderbook_items <br/> get_depth_for_a_market                            |
| QuidaxOrder        | get_all <br/> create <br /> cancle <br/> get_details                                                                                                                                    |
| QuidaxQuote        | get                                                                                                                                                                                     |
| QuidaxTrade        | for_user <br/> for_market                                                                                                                                                               |
| QuidaxUser         | get_account_details <br/> create_sub_account <br/> get_all_sub_accounts <br/> edit_account <br/>                                                                                        |
| QuidaxWallet       | get_user_wallets <br/> get_user_wallet <br/> get_payment_address <br/> get_payment_address_by_id <br/> get_payment_addresses <br/> create_crypto_payment_address <br/> validate_address |
| QuidaxWithdrawal   | get_all_withdrawals_detail <br/> get_detail <br/> cancel                                                                                                                                |

## Development

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aremu-smog/quidax-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
