defmodule Kiosk do
  import Kiosk.Utils

  @moduledoc """
  Documentation for `Kiosk`.
  """
  def display(params) do
    {:ok, render_template(:index, context(:index))}
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
