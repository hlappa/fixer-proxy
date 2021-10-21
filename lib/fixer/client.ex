defmodule Fixer.Client do
  use Tesla

  plug Tesla.Middleware.BaseUrl, System.get_env("FIXER_URL")
  plug Tesla.Middleware.Query, [access_key: System.get_env("FIXER_API_KEY")]
  plug Tesla.Middleware.JSON

  def get_historical(date, other_currency) do
    get(date, query: [symbols: "#{other_currency}"])
  end
end
