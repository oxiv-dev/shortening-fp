defmodule ShortenWeb.PageController do
  use ShortenWeb, :controller
  alias Shorten.TableOps

  def encode(conn, params) do
    try do
      url =
        params
        |> Map.fetch!("url")

      TableOps.shorten_link(conn, url)
    rescue
      e ->
        json(conn, %{"status" => "error", "message" => "'url' field is missing"})
    end
  end

  def decode(conn, params) do
    url =
      params
      |> Map.fetch!("url")
      |> String.split("http://shortlink.io/")
      |> List.last()

    TableOps.get_link_by_id(conn, url)
  end
end
