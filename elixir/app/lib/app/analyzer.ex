defmodule App.Analyzer do
  @moduledoc """
  Responsible for starting the file analysis
  """


  def execute do
    start("files/input999.txt")
  end

  def start(file) do
    data = open(file)
    start_proposals()
    data
      |> Enum.map(&(App.Event.new(&1)))
      |> Enum.sort(&(&1.date <= &2.date))
      |> Enum.map(&(process_event(&1)))

    #   |> Enum.map(&(%{
    #     event: &1,
    #     data: App.Event.parser_data(&1)
    #   }))

    # proposal = events
    #   |> Enum.filter(&(&1.event.type == "proposal"))

    Agent.get(__MODULE__, fn proposals -> proposals end)
  end

  defp open(file) do
    {:ok, contents} = File.read(file)
    contents
    |> String.split("\n", trim: true)
  end

  def start_proposals do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def process_event(%App.Event{action: action} = event) when action == "created" do # created
  IO.puts "create"
    Agent.update(__MODULE__, fn(proposals) ->
      [ App.Event.parser_data(event) | proposals]
    end)
  end

  def process_event(%App.Event{action: action} = event) when action == "updated" do
    IO.puts "update"
    Agent.update(__MODULE__, fn(proposals) ->
      item = App.Event.parser_data(event)
      proposals
      |> Enum.map(&(if(&1.id ==item.id, do: Map.merge(&1, item), else: &1)))
    end)
  end

  def process_event(%App.Event{action: action} = event) when action == "removed" do
    IO.puts "remove"
    Agent.update(__MODULE__, fn(proposals) ->
      id = App.Event.parser_data(event)
      proposal = proposals
        |> Enum.filter(&(&1.id == id))
      proposals -- proposal
    end)
  end

end
