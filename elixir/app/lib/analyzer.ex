defmodule Analyzer do
  @moduledoc """
  Responsible for starting the file analysis
  """
  alias Analyzer.File
  alias Analyzer.Event
  alias Analyzer.Aggregator

  def start() do
    start("files/input999.txt")
  end

  def start(path) do
    File.read_file(path)
    |> Enum.map(&(Event.receive(&1)))
    |> process
  end

  defp process(events) do
    events
    |> Aggregator.make_proposals
  end

end
