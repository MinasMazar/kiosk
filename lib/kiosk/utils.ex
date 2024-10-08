defmodule Kiosk.Utils do
  def now do
    with {:ok, time} <- DateTime.now(timezone()), do: time
  end

  defp timezone, do: Application.get_env(:fra_martino, :timezone, "UTC")
end
