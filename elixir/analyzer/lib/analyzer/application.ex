defmodule Analyzer.Application do
  @moduledoc """
  Application Supervisor
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Analyzer.Server, [])
    ]

    options = [
      name: Analyzers.Supervisor,
      strategy: :simple_one_for_one
    ]

    Supervisor.start_link(children, options)
  end

end
