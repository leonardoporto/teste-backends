defmodule Analyzer.Server do
  @moduledoc """
  Server
  """
  use GenServer

  alias Analyzer.{Aggregator, Event, Proposal}

  def start_link() do
    IO.inspect node()
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, []}
  end

  def handle_call({:analyzer, lines}, _from, results) do
    IO.puts "INICIO PROCESSAMENTO"
    ids = lines
    |> Enum.map(&Event.receive(&1))
    |> process
    ids |> Enum.join(",") |> IO.puts
    {:reply, ids, [ids | results]}
  end

  defp process(events) do
    events
    |> Aggregator.make_proposals()
    |> Enum.map(&Proposal.is_valid?/1)
    |> Enum.map(&extract/1)
    |> result()
  end

  defp extract({:is_valid, id}), do: id
  defp extract({:is_invalid}), do: false

  defp result(ids), do: ids |> Enum.filter(& &1)

end
