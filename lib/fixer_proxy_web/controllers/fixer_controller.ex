defmodule FixerProxyWeb.FixerController do
  use FixerProxyWeb, :controller

  def historical(conn, %{"start_date" => start_date, "end_date" => end_date, "currencies" => currencies}) do
    case start_date == end_date do
      true -> 
        case Fixer.historical(start_date, currencies) do
          {:ok, resp} -> conn |> json(resp)
          {:error, err_resp} -> conn |> put_status(err_resp["error"]["code"]) |> json(err_resp["error"]["info"])
        end
      false ->
        case get_multiple_entries(start_date, end_date, currencies) do
          {:ok, resp} -> conn |> json(resp)
          {:error, err_map} -> conn |> put_status(err_map.code) |> json(err_map.msg)
        end
    end
  end

  # Private

  defp get_multiple_entries(start_date, end_date, currency) do
    try do
      starting = Date.from_iso8601!(start_date)
      ending = Date.from_iso8601!(end_date)
      result_list = Date.range(starting, ending)
             |> Enum.to_list()
             |> Enum.map(fn(n) -> Date.to_string(n) end)
             |> Enum.map(&Task.async(fn -> {&1, Fixer.historical(&1, currency)} end))
             |> Enum.map(&Task.await/1)
             |> Enum.map(fn(x) -> elem(x, 1) |> elem(1) end)

      {:ok, result_list}
    rescue
      e in ArgumentError -> {:error, %{code: 400, msg: e.message}}
    end
  end
end
