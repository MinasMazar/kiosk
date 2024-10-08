defmodule Kiosk.Utils do
  def now do
    with {:ok, time} <- DateTime.now(timezone()), do: time
  end

  defp timezone, do: Application.get_env(:kiosk, :timezone, "UTC")
end
