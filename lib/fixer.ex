defmodule Fixer do
  alias Fixer.Client
  alias Fixer.Cache

  def historical(date, other_currency) do
    with {:ok, entry} <- Cache.get_value(date, other_currency) do
      {:ok, entry}
    else
      {:error, _msg} ->
        {:ok, resp} = Client.get_historical(date, other_currency)

        case resp.body["success"] do
          true ->
            # Update new entry to cache asynchronously without blocking
            # the response to client
            Task.start(fn -> Cache.set_value(date, other_currency, resp.body) end)

            {:ok, resp.body}
          false ->
            {:error, resp.body}
        end
    end
  end
end
