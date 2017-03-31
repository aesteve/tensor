defmodule Tensor.Plug do
  import Plug.Conn
  import Rackla
  alias Tensor.Router, as: Routes

  def init([]) do
    false # FIXME : fulfill routes from pg
  end

  def call(conn, _opts) do
    case Routes.extract_route(conn) do
      {nil, _} ->
        conn
        |> send_resp(404, "Not Found")
      {route, params} ->
        conn
        |> send_resp(302, "Found")
    end
  end

end
