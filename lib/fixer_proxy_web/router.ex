defmodule FixerProxyWeb.Router do
  use FixerProxyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FixerProxyWeb do
    pipe_through :api
    scope "/fixer" do
      get "/historical", FixerController, :historical
    end
  end
end
