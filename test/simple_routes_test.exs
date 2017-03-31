defmodule Tensor.SimpleRoutesTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Tensor.Router

  @routes [
    %{pattern: ~r/^\/api\/a\/b[.]*/, methods: ["GET", "POST"], headers: %{}},
    %{pattern: ~r/^\/api\/with_headers[.]*/, methods: ["GET"], headers: %{"content-type": ~r/application\/json/}}
  ]
  @empty_route {nil, %{}}

  test "Match with simple route and method" do
    conn =
        :get
        |> conn("/api/a/b")

    assert extract_route(@routes, conn) != @empty_route
  end

  test "Match with POST and no capture" do
    conn =
        :post
        |> conn("/api/a/b")

    assert extract_route(@routes, conn) != @empty_route
  end

  test "Do not match if wrong path" do
    conn =
        :get
        |> conn("/api2/a/b")

    assert extract_route(@routes, conn) == @empty_route
  end

  test "Do not match if wrong method" do
    conn =
        :put
        |> conn("/api/a/b")

    assert extract_route(@routes, conn) == @empty_route
  end

  test "Do not match if header's constraint and no headers" do
    conn =
        :get
        |> conn("/api/with_headers")

    assert extract_route(@routes, conn) == @empty_route
  end

  test "Do not match if header's constraint and wrong header" do
    conn =
        :get
        |> conn("/api/with_headers")
        |> put_req_header("content-type", "text/html")

    assert extract_route(@routes, conn) == @empty_route
  end

  test "Match with correct header" do
    conn =
        :get
        |> conn("/api/with_headers")
        |> put_req_header("content-type", "application/json")

    assert extract_route(@routes, conn) != @empty_route
  end

end
