defmodule Kiosk.Server do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_) do
    {:ok, []}
  end
end
