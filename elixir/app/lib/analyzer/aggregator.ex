defmodule Analyzer.Aggregator do
  @moduledoc """
  Responsible for grouping the information
  """
  def make_proposals(events) do
    events
    |> Enum.filter(&(&1.type == "proposal"))
    |> Enum.reduce(%{}, fn event, proposals ->
      make_proposal(proposals, event)
    end)
    |> Enum.map(fn {id, proposal} ->
      {id, mount_proposal(proposal, get_events_from_proposal(id, events))}
    end)
    |> Enum.into(%{})
  end

  defp make_proposal(proposals, %{action: action} = event)
       when action in ["created", "updated"] do
    Map.put(proposals, event.data.id, event.data)
  end

  defp make_proposal(proposals, %{action: "removed"} = event) do
    Map.delete(proposals, event.data)
  end

  defp get_events_from_proposal(proposal_id, events) do
    events
    |> Enum.filter(&(&1.type in ["warranty", "proponent"]))
    |> Enum.filter(&(&1.data.proposal_id == proposal_id))
  end

  defp mount_proposal(proposal, events_proposal) do
    events_proposal
    |> Enum.reduce(proposal, fn event, new_proposal ->
      attach(new_proposal, event)
    end)
  end

  defp attach(proposal, %{type: "warranty"} = event) do
    Map.put(proposal, :warranties, Map.put(proposal.warranties, event.data.id, event.data))
  end

  defp attach(proposal, %{type: "warranty", action: "removed"} = event) do
    Map.put(proposal, :warranties, Map.delete(proposal.warranties, event.data.id))
  end

  defp attach(proposal, %{type: "proponent"} = event) do
    Map.put(proposal, :proponents, Map.put(proposal.proponents, event.data.id, event.data))
  end

  defp attach(proposal, %{type: "proponent", action: "removed"} = event) do
    Map.put(proposal, :proponents, Map.delete(proposal.proponents, event.data.id))
  end
end
