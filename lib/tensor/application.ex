defmodule Tensor.Application do

  use Application
  alias Tensor.Router, as: Routes
  alias Tensor.RouteRegistry, as: Registry

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    IO.puts("Starting Tensor")

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Tensor.Plug, [], [port: 4000])
    ]

    # {:ok, pid} = Registry.start_link
    # Routes.clear_routes()


    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tensor.Supervisor]
    Supervisor.start_link(children, opts)

  end

end
