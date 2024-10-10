defmodule Kiosk.KV do
  use Agent

  def start_link(store) do
    Agent.start_link(fn -> store end, name: __MODULE__)
  end

  def get(key) do
    Agent.get(__MODULE__, fn store -> Map.get(store, key) end)
  end

  def set(key, value) do
    with :ok <- Agent.update(__MODULE__, fn store -> Map.put(store, key, value) end) do
      value
    end
  end

  def get_or_set(key, fun) when is_function(fun) do
    get(key) || set(key, fun.())
  end

  def page() do
    get(:page)
  end

  def set_page(page) do
    set(:page, page)
  end
end
