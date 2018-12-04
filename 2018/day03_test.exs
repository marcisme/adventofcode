defmodule Day03 do
  defmodule Claim do
    defstruct [:id, :x, :y, :w, :h]

    def new(s) do
      fields = Regex.named_captures(~r/#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)/, s)
      id = fields["id"] |> String.to_integer
      x = fields["x"] |> String.to_integer
      y = fields["y"] |> String.to_integer
      w = fields["w"] |> String.to_integer
      h = fields["h"] |> String.to_integer
      %Claim{id: id, x: x, y: y, w: w, h: h}
    end
  end

  def overlap(claims) do
    overlap_map(claims) |> Enum.count(fn {_k, v} -> v > 1 end)
  end

  defp overlap_map(claims) do
    Enum.reduce(claims, %{}, fn claim_string, counts ->
      claim = Claim.new(claim_string)
      Enum.reduce(claim.x..claim.x+claim.w-1, counts, fn i, counts ->
        Enum.reduce(claim.y..claim.y+claim.h-1, counts, fn j, counts ->
          Map.update(counts, {i, j}, 1, &(&1 + 1))
        end)
      end)
    end)
  end

  def non_overlapping_id(claims) do
    overlap_map = overlap_map(claims)
    Enum.reduce_while(claims, nil, fn claim_string, _ ->
      claim = Claim.new(claim_string)
      outer_result = Enum.reduce_while(claim.x..claim.x+claim.w-1, nil, fn i, _ ->
        inner_result = Enum.reduce_while(claim.y..claim.y+claim.h-1, nil, fn j, _ ->
          if overlap_map[{i, j}] == 1 do
            {:cont, claim.id}
          else
            {:halt, nil}
          end
        end)
        case inner_result do
          nil -> {:halt, nil}
          id -> {:cont, id}
        end
      end)
      case outer_result do
        nil -> {:cont, nil}
        id -> {:halt, id}
      end
    end)
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
    test "test claims" do
      assert Day03.non_overlapping_id([
        "#1 @ 1,3: 4x4",
        "#2 @ 3,1: 4x4",
        "#3 @ 5,5: 2x2"
      ]) == 3
    end

    test "answer" do
      answer = parse(@input_file) |> Day03.non_overlapping_id
      assert answer == 1260
    end
  end
end
