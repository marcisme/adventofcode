ExUnit.start()

defmodule TestHelper do
  def parse(file) do
    file
    |> File.read!
    |> String.split
  end

  def parse_integers(file) do
    file
    |> parse
    |> Enum.map(&String.to_integer/1)
  end
end
