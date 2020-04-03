defmodule FileCollector do
  @moduledoc """
  Documentation for `FileCollector`.
  """
  
  def start() do
    {:ok, pid} = Supervisor.start_child(FileCollector.Supervisor, [])
    pid
  end

end
