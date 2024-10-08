defmodule Kiosk.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_header("Location", "/kiosk")
    |> send_resp(302, "/kiosk")
  end

  get "/kiosk" do
    {status, result} =
      case Kiosk.display(conn.body_params) do
	{:ok, result} -> {200, result}
	{:error, reason} -> {400, reason}
      end
    send_resp(conn, status, result)
  end

  get "/dev" do
    send_resp(conn, 200, "This is a dev page.")
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
