defmodule FileCollector.Watch do
  @moduledoc """
  Watch
  """

  use GenServer

  alias FileCollector.File

  @analyzer_server :analyzer@NB145

  require Logger

  def start_link() do
    IO.inspect node()
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    Logger.info("start watcher")
    {:ok, watcher_pid} = FileSystem.start_link(dirs: ["files/input"])
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid} = state) do

    case List.last(events) do
      :removed ->
        Logger.info("removed file #{path}")
      :created ->
        Logger.info("receive file #{path}")
      :modified ->
        Logger.info("modified file #{path}")
      :closed ->
        Logger.info("upload completed #{path}")
        File.read_file(path)
        |> check()
        |> File.make_output(path)
      _ ->
        Logger.info("event not mapped #{List.last(events)}")
    end

    {:noreply, state}

  end

  def handle_info({:file_event, watcher_pid, :stop}, state) do
    {:noreply, state}
  end

  defp check(lines) do

    Node.connect(@analyzer_server)

    :rpc.call(@analyzer_server,
      Analyzer,
      :start,
      []
    ) |> Analyzer.analyzer(lines)

  end

end
