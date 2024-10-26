defmodule Kiosk.Browser do
  use GenServer

  def open(url: url) do
    System.cmd("midori", ~w[-e fullscreen #{url}])
  end

  def reload do
    System.cmd("midori", ~w[-e tab-reload])
  end

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    {:ok,
     %{url: "http://localhost:4000/"}
     |> schedule_start()}
  end

  def state() do
    GenServer.call(__MODULE__, :state)
  end

  def handle_call(:state, _, state), do: {:reply, state, state}

  def handle_info(:start, state) do
    IO.puts("Starting browser..")
    port = Port.open({:spawn, ~s[midori -e fullscreen "#{state.url}"]}, [])
    ref = Port.monitor(port)
    {:noreply, Map.put(state, :port, {port, ref})}
  end

  def handle_info({_port, {:data, _message}}, state) do
    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :port, _object, _reason}, state) do
    {:noreply, state}
  end

  defp schedule_start(state) do
    Process.send_after(self(), :start, 4_000) && state
  end
end
