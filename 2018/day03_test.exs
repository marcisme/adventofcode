defmodule Day03 do
  def overlap(claims) do
    Enum.reduce(claims, %{}, fn claim, counts ->
      fields = Regex.named_captures(~r/#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)/, claim)
      x = fields["x"] |> String.to_integer
      y = fields["y"] |> String.to_integer
      w = fields["w"] |> String.to_integer
      h = fields["h"] |> String.to_integer
      Enum.reduce(x..x+w-1, counts, fn i, counts ->
        Enum.reduce(y..y+h-1, counts, fn j, counts ->
          Map.update(counts, {i, j}, 1, &(&1 + 1))
        end)
      end)
    end) |> Enum.count(fn {_k, v} -> v > 1 end)
  end
end

Code.require_file("test_helper.exs")

defmodule Day03Test do
  use ExUnit.Case, async: true
  import TestHelper

  @input_file "day03.input"

  describe "part 1" do
    test "test claims" do
      assert Day03.overlap([
        "#1 @ 1,3: 4x4",
        "#2 @ 3,1: 4x4",
        "#3 @ 5,5: 2x2"
      ]) == 4
    end

    test "answer" do
      answer = parse(@input_file) |> Day03.overlap
      assert answer == 116489
    end
  end

  # "#1 @ 1,3: 4x4",
  # 1,3 2,3 3,3 4,3
  # 1,4 2,4 3,4 4,4
  # 1,5 2,5 3,5 4,5
  # 1,6 2,6 3,6 4,6

  describe "part 2" do
  end
end
