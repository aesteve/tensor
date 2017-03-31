defmodule Tensor.RouteRegistry do

  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:get, key, caller} ->
        send caller, Map.get(map, key)
        loop(map)
      {:put, key, value} ->
        loop(Map.put(map, key, value))
      {:find, key, function} ->
        Enum.find(map, function)
        loop(map)
    end
  end

end
