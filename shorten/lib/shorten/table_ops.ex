defmodule Shorten.TableOps do
  use ShortenWeb, :controller

  def shorten_link(conn, url) do
    if url == "" or url == " " or url == nil do
      json(conn, %{"status" => "error", "message" => "Not valid url"})
    else
      if length(:ets.lookup(:links, url)) == 0 do
        :ets.insert_new(:links, {url, create_key()})
        :ets.insert_new(:ids, {elem(get_record(:links, url), 1), url})
      end

      {key, value} = get_record(:links, url)
      json(conn, %{"status" => "ok", "url" => key, "short_url" => "http://shortlink.io/#{value}"})
    end
  end

  def get_record(table, url) do
    List.first(:ets.lookup(table, url))
  end

  def create_key() do
    alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
    length = 9

    alphabet
    |> Enum.take_random(length)
    |> to_string()
  end

  def get_link_by_id(conn, id) do
    try do
      {key, value} = get_record(:ids, id)
      json(conn, %{"status" => "ok", "url" => value, "short_url" => "http://shortlink.io/#{key}"})
    rescue
      e ->
        json(conn, %{"status" => "error", "message" => "Link not found"})
    end
  end
end
