defmodule Kiosk do
  alias Kiosk.{Browser, KV}
  require Logger
  import Kiosk.Utils

  defdelegate page(), to: KV
  defdelegate set_page(page), to: KV
  defdelegate reload(), to: Browser

  def display_page(page \\ page()) do
    Kiosk.set_page(page)
    Browser.reload()
  end

  @moduledoc """
  Documentation for `Kiosk`.
  """
  def display(_params) do
    page = KV.page()
    Logger.info("Displaying page #{page}")
    {:ok, render_template(page, context(page))}
  end

  defp render_template(template, ctx) when is_binary(template) do
    String.to_atom(template) |> render_template(ctx)
  end

  defp render_template(template, ctx) do
    path = "../kiosk/templates/#{template}.html"
    Path.expand(path, __ENV__.file)
    |> EEx.eval_file(ctx)
  end

  defp context(template) do
    [
      assigns: (
	context_for_template(template)
	|> Enum.into(runtime_context())
      )
    ]
  end

  defp runtime_context do
    time = Calendar.strftime(now(), "%I:%M%p")
    date = Calendar.strftime(now(), "%x")
    [
      time: time,
      date: date,
      footer: "Made with 💜 in Elixir"
    ]
  end

  defp context_for_template(template) do
    Application.get_env(:kiosk, template, [])
  end
end
