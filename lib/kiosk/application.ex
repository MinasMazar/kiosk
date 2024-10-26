defmodule Kiosk.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Kiosk.Worker.start_link(arg)
      {Bandit, plug: Kiosk.Router, scheme: :http, port: 4000},
      {Kiosk.KV, %{}},
      {Kiosk.Server, []},
      %{id: Kiosk.Browser, start: {Kiosk.Browser, :start_link, []}, restart: :temporary}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kiosk.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
