require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

# Assuming your API key is set in the environment variable as EXCHANGE_RATE_KEY
api_key = ENV.fetch("EXCHANGERATE_API")

get "/" do
  api_url = "https://api.exchangerate.host/list?access_key=#{api_key}"
  response = HTTP.get(api_url)
  @currencies = JSON.parse(response.to_s)["symbols"]
  erb :homepage
end

get "/:from_currency" do
  @original_currency = params[:from_currency]
  erb :currency_page
end

get "/:from_currency/:to_currency" do
  @original_currency = params[:from_currency]
  @destination_currency = params[:to_currency]
  api_url = "https://api.exchangerate.host/convert?access_key=#{api_key}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  response = HTTP.get(api_url)
  @conversion_result = JSON.parse(response.to_s)["result"]
  erb :conversion_page
end
