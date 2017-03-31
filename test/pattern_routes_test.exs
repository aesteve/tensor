defmodule Tensor.PatternRoutesTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Tensor.Router

  @routes [
    %{pattern: ~r/^\/api\/v(?<version>[^\/]+)\/[.]*/, methods: ["GET", "POST"], headers: %{}},
    %{pattern: ~r/^\/api\/with_headers\/(?<endpoint>[^\/]+)[.]*/, methods: ["GET"], headers: %{"content-type": ~r/application\/(?<content>[^\/]*)/}},
    %{pattern: ~r/^\/api\/multiple\/(?<endpoint1>[^\/]+)\/(?<endpoint2>[^\/]+)[.]*/, methods: ["GET"], headers: %{"accept" => ~r/(?<accept1>[^\/]*)\/(?<accept2>[^\/]*)/, "content-type": ~r/(?<content1>[^\/]*)\/(?<content2>[^\/]*)/}}
  ]

  test "Match and group" do
    conn =
        :get
        |> conn("/api/v1/test")

    assert extract_route(@routes, conn) == {Enum.at(@routes, 0), %{"version" => "1"}}
  end

  test "Match and group with 1 header" do
    conn =
        :get
        |> conn("/api/with_headers/test")
        |> put_req_header("content-type", "application/json")

    assert extract_route(@routes, conn) == {Enum.at(@routes, 1), %{"endpoint" => "test", "content" => "json"}}
  end

  test "Match and group with multiple paths / headers" do
    conn =
        :get
        |> conn("/api/multiple/test1/test2")
        |> put_req_header("content-type", "application/json")
        |> put_req_header("accept", "text/csv")

    assert extract_route(@routes, conn) == {Enum.at(@routes, 2), %{"endpoint1" => "test1", "endpoint2" => "test2", "content1" => "application", "content2" => "json", "accept1" => "text", "accept2" => "csv"}}
  end

end
