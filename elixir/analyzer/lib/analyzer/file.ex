defmodule Analyzer.File do
  @moduledoc """
  Responsible for file control
  """
  def read_file(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
