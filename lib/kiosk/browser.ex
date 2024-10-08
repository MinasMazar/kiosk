defmodule Kiosk.Browser do
  @reload_timeout 90 * 1000
  use GenServer

  def open(url: url) do
    System.cmd("midori", ~w[-e fullscreen "#{url}"])
  end

  def reload do
    Systemc.cmd("midori", ~w[-e tab-reload])
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_) do
    {:ok,
     %{url: "http://localhost:4000/", reload_timeout: @reload_timeout}
     |> schedule_start()
     |> schedule_reload()}
  end

  def handle_info(:start, state) do
    port = Port.open({:spawn, open(url: state.url)}, [])
    ref = Port.monitor(port)
    {:noreply, {port, ref}}
  end

  def handle_info(:reload, state) do
    reload() && {:noreply, state}
  end

  def handle_info({_port, {:data, _message}}, state) do
    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :port, _object, _reason}, state) do
    {:noreply, state}
  end

  defp schedule_start(state) do
    send(self(), :start) && state
  end

  defp schedule_reload(state) do
    Process.send_after(self(), :reload, state.reload_timeout) && state
  end
end
