defmodule FileCollector.File do
  @moduledoc """
  File
  """

  def read_file(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def make_output(result, path) when is_list(result) do
    path
    |> String.replace(~r/input/, "output", global: true)
    |> File.write!(result |> Enum.join(","))
  end

end
