ExUnit.start()

defmodule TestHelper do
  def parse(file) do
    File.read!(file)
    |> String.split
    |> Enum.map(&String.to_integer/1)
  end
end
