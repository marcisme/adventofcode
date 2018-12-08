defmodule Day05 do
  def num_remaining_units(polymer) when is_binary(polymer) do
    polymer
    |> String.graphemes
    |> num_remaining_units
  end
  def num_remaining_units(graphemes) do
    graphemes
    |> Enum.reduce([], &react/2)
    |> Enum.count
  end

  defp react(grapheme, []), do: [grapheme]
  defp react(grapheme, [last | rest] = acc) do
    if sort_of_equal(grapheme, last) do
      rest
    else
      [grapheme | acc]
    end
  end

  defp sort_of_equal(a, b) do
    cond do
      # AA, aa
      a == b -> false
      # aA, Aa become aA, AA
      a == String.upcase(b) -> true
      # aA, Aa become AA, Aa
      String.upcase(a) == b -> true
      # ab
      true -> false
    end
  end

  def find_shortest(polymer) do
    graphemes = String.graphemes(polymer)
    97..122
    |> Enum.map(&(IO.chardata_to_string([&1])))
    |> Enum.reduce(0, fn unit, shortest ->
      count =
        graphemes
        |> Enum.reject(&(&1 == unit || &1 == String.upcase(unit)))
        |> num_remaining_units
      cond do
        shortest == 0 -> count
        count < shortest -> count
        true -> shortest
      end
    end)
  end
end

Code.require_file("test_helper.exs")

defmodule Day05Test do
  use ExUnit.Case, async: true
  import TestHelper

  @input_file "day05.input"

  describe "part 1" do
    test "aa" do
      assert Day05.num_remaining_units("aa") == 2
    end

    test "AA" do
      assert Day05.num_remaining_units("AA") == 2
    end

    test "aA" do
      assert Day05.num_remaining_units("aA") == 0
    end

    test "Aa" do
      assert Day05.num_remaining_units("Aa") == 0
    end

    test "ab" do
      assert Day05.num_remaining_units("ab") == 2
    end

    test "aabB" do
      assert Day05.num_remaining_units("aabB") == 2
    end

    test "abBA" do
      assert Day05.num_remaining_units("abBA") == 0
    end

    test "abAB" do
      assert Day05.num_remaining_units("abAB") == 4
    end

    test "aabAAB" do
      assert Day05.num_remaining_units("aabAAB") == 6
    end

    test "dabAcCaCBAcCcaDA" do
      assert Day05.num_remaining_units("dabAcCaCBAcCcaDA") == 10
    end

    test "answer" do
      answer = parse(@input_file) |> List.first |> Day05.num_remaining_units
      assert answer == 11042
    end
  end

  describe "part 2" do
    test "dabAcCaCBAcCcaDA" do
      assert Day05.find_shortest("dabAcCaCBAcCcaDA") == 4
    end

    test "answer" do
      answer = parse(@input_file) |> List.first |> Day05.find_shortest
      assert answer == 6872
    end
  end
end
