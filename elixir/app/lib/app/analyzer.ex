defmodule App.Analyzer do
  @moduledoc """
  Responsible for starting the file analysis
  """

  def start(file) do
    data = open(file)

    # Enum.slice(data[0], 0..4)
    data[0]
  end

  defp open(file) do
    {:ok, contents} = File.read(file)
    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.split(&1, ",")))
  end
end
