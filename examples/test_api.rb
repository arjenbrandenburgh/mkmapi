require 'mkmapi'
require 'dotenv/load'

session = Mkmapi.auth(
  consumer_key: ENV['CARDMARKET_CONSUMER_KEY'],
  consumer_secret: ENV['CARDMARKET_CONSUMER_SECRET'], 
  token: ENV['CARDMARKET_ACCESS_TOKEN'],
  token_secret: ENV['CARDMARKET_ACCESS_TOKEN_SECRET']
)

marketplace = session.marketplace

# Get list of games
games = marketplace.games
puts "Games: #{games.inspect}"
