defmodule Kiosk.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/" do
    {status, result} =
      case Kiosk.display(conn.body_params) do
	{:ok, result} -> {200, result}
	{:error, reason} -> {400, reason}
      end
    send_resp(conn, status, result)
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
