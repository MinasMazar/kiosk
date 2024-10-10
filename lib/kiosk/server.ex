defmodule Kiosk.Server do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_) do
    Kiosk.set_page(:kiosk)
    {:ok, schedule_next([])}
  end

  def handle_info(:run, state) do  
    page = Enum.random(~w[kiosk dev]a)
    Kiosk.display_page(page)
    {:noreply, schedule_next(state)}
  end

  def schedule_next(state) do
    Process.send_after(self(), :run, 30_000)
    state
  end
end
