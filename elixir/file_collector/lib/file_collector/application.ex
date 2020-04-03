defmodule FileCollector.Application do
  @moduledoc """
  Application Supervisor
  """
  use Application

  def start(_type, args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(FileCollector.Watch, args)
    ]

    options = [
      name: FileCollector.Supervisor,
      strategy: :one_for_one
    ]

    Supervisor.start_link(children, options)
  end

end
