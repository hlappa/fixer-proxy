defmodule Fixer.Cache do
  use GenServer
  require Logger

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default)
  end

  def get_value(date, currency) do
    key = "#{date}#{currency}"

    case :ets.lookup(:historicals, key) do
      [{^key, entry}] -> {:ok, entry}
      [] ->
        Logger.info("Cache miss with #{date} and #{currency}")
        {:error, "Cache miss with #{date} and #{currency}"}
    end
  end

  def set_value(date, currency, historic_entry) do
    key = "#{date}#{currency}"
    :ets.insert(:historicals, {key, historic_entry})
    Logger.info("Set value for #{key} in cache")
    :ok
    end


  # Server callbacks

  def init(_args \\ %{}) do
    :ets.new(:historicals, [:set, :named_table, :public])

    {:ok, %{}}
  end
end
