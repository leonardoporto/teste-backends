defmodule Analyzer do
  @moduledoc """
  Responsible for starting the file analysis
  """
  alias Analyzer.File
  alias Analyzer.Event
  alias Analyzer.Aggregator
  alias Analyzer.Proposal

  def start() do
    start("files/input999.txt")
  end

  def start(path) do
    File.read_file(path)
    |> Enum.map(&Event.receive(&1))
    |> process
  end

  defp process(events) do
    events
    |> Aggregator.make_proposals()
    |> Enum.map(&Proposal.is_valid?(&1))
    |> Enum.map(&extract(&1))
    |> result()
    |> IO.puts()
  end

  defp extract({:is_valid, id}), do: id
  defp extract({:is_invalid}), do: false

  defp result(ids), do: ids |> Enum.filter(& &1) |> Enum.join(",")
end
