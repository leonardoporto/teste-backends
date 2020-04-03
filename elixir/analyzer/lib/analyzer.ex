defmodule Analyzer do
  @moduledoc """
  Responsible for starting the file analysis
  """
  def start() do
    {:ok, pid} = Supervisor.start_child(Analyzers.Supervisor, [])
    pid
  end

  def analyzer(pid, lines) do
    GenServer.call(pid, {:analyzer, lines})
  end
end
