defmodule Analyzer do
  @moduledoc """
  Responsible for starting the file analysis
  """
  alias Analyzer.File
  alias Analyzer.Event

  def start() do
    start("files/input999.txt")
  end

  def start(path) do
    File.read_file(path)
    |> Enum.map(&(Event.receive(&1)))
  end

end
