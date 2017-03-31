defmodule Tensor.PlugSupervisor do
  use Supervisor

  def start_link do
    IO.puts("Starting Supervisor")
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Tensor.Plug, [], [port: 4000])
    ]
    supervise(children, strategy: :one_for_one)
  end

end
