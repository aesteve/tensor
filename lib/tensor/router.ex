defmodule Tensor.Router do

  import Plug.Conn

  def extract_route(routes, conn) do
    matcher = fn route ->
      Regex.match?(route.pattern, conn.request_path) and
        Enum.any?(route.methods, &(&1 == conn.method)) and
        headers_match(route.headers, conn)
    end
    {Enum.find(routes, matcher), %{}}
    |> extract_from_path(conn)
    |> extract_from_headers(conn)
  end

  defp extract_from_path({nil, map}, _) do {nil, map} end
  defp extract_from_path({route, map}, conn) do
    captures = Regex.named_captures(route.pattern, conn.request_path)
                |> Map.merge(map)
    {route, captures}
  end

  defp extract_from_headers({nil, map}, _) do {nil, map} end
  defp extract_from_headers({route, map}, conn) do
    extracted = Enum.map(route.headers, &extract_from_header(&1, conn))
                |> Enum.reduce(map, &Map.merge(&2, &1))
    {route, extracted}
  end

  defp extract_from_header({name, regex}, conn) do
    conn
    |> get_req_header(to_string(name))
    |> extract_header(regex)
  end

  defp extract_header([header], regex) do
    Regex.named_captures(regex, header)
  end
  defp extract_header([], _) do %{} end
  defp extract_header(nil, _) do %{} end

  defp headers_match(headers, conn) do
    match = fn {name, value_regex} ->
      conn
      |> get_req_header(name |> to_string)
      |> header_match(value_regex)
    end
    Enum.all?(headers, match)
  end

  defp header_match([header], regex) do
    Regex.match?(regex, header)
  end
  defp header_match([], _) do false end
  defp header_match(nil, _) do false end

end
