defmodule Taskmanager.Application do
  alias Taskmanager.Manager
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Taskmanager.Worker.start_link(arg)
      # {Taskmanager.Worker, arg}
      Manager.child_spec([]),
      MainMenu.child_spec([])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Taskmanager.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
