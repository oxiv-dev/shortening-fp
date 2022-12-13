defmodule ShortenTest do
  use Plug.Test
  use ShortenWeb.ConnCase
  alias Shorten.TestHelper
  alias ShortenWeb.Router

  @opts ShortenWeb.Router.init([])

  test "url field is mandatory" do
    request = conn(:post, "/encode", %{"field" => "test"})
    response = Router.call(request, @opts)

    assert TestHelper.parse_resp_body(response) == %{
             "status" => "error",
             "message" => "'url' field is missing"
           }
  end

  test "url field must be filled (empty)" do
    request = conn(:post, "/encode", %{"url" => ""})
    response = Router.call(request, @opts)

    assert TestHelper.parse_resp_body(response) == %{
             "status" => "error",
             "message" => "Not valid url"
           }
  end

  test "url field must be filled (space)" do
    request = conn(:post, "/encode", %{"url" => " "})
    response = Router.call(request, @opts)

    assert TestHelper.parse_resp_body(response) == %{
             "status" => "error",
             "message" => "Not valid url"
           }
  end

  test "url field must be filled (nil)" do
    request = conn(:post, "/encode", %{"url" => nil})
    response = Router.call(request, @opts)

    assert TestHelper.parse_resp_body(response) == %{
             "status" => "error",
             "message" => "Not valid url"
           }
  end

  test "/encode works properly" do
    request = conn(:post, "/encode", %{"url" => "http://test.url"})
    response = Router.call(request, @opts)

    res =
      response
      |> TestHelper.parse_resp_body()
      |> Map.get("status")

    assert res == "ok"
  end

  test "/decode can decode only previously encoded strings" do
    request = conn(:post, "/decode", %{"url" => "http://test.url"})
    response = Router.call(request, @opts)

    assert TestHelper.parse_resp_body(response) == %{
             "status" => "error",
             "message" => "Link not found"
           }
  end

  test "/decode works properly" do
    pre_request = conn(:post, "/encode", %{"url" => "http://test.url"})
    pre_request_response = Router.call(pre_request, @opts)

    short_url =
      pre_request_response
      |> TestHelper.parse_resp_body()
      |> Map.get("short_url")

    request = conn(:post, "/decode", %{"url" => short_url})
    response = Router.call(request, @opts)

    res =
      response
      |> TestHelper.parse_resp_body()
      |> Map.fetch!("url")

    assert res == "http://test.url"
  end
end
