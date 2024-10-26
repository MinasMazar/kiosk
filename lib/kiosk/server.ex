defmodule Kiosk.Server do
  @default_timeout 6 * 60
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_) do
    Kiosk.set_page(:kiosk)
    {:ok, schedule_next(%{timeout: @default_timeout})}
  end

  def set_timeout(pid \\ __MODULE__, timeout) do
    GenServer.call(pid, {:state, %{timeout: timeout}})
  end

  def handle_info(:run, state) do  
    page = Enum.random(~w[kiosk dev]a)
    Kiosk.display_page(page)
    {:noreply, schedule_next(state)}
  end

  def handle_call({:state, overrides}, _, state) do
    with state <- Map.merge(state, overrides) do
      {:reply, state, state}
    end
  end

  def schedule_next(state) do
    Process.send_after(self(), :run, state.timeout * 1000)
    state
  end
end
