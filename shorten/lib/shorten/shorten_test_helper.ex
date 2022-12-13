defmodule Shorten.TestHelper do
  def parse_resp_body(response) do
    response.resp_body
    |> Jason.decode()
    |> elem(1)
  end
end
