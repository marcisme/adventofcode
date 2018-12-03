defmodule Day02 do
  def checksum(ids) do
    {twices, thrices} =
      Enum.reduce(ids, {0, 0}, fn id, {twices, thrices} ->
        counts =
          String.graphemes(id)
          |> Enum.reduce(%{}, fn grapheme, counts ->
            Map.update(counts, grapheme, 1, &(&1 + 1))
          end)
        {twice, thrice} = Enum.reduce(counts, {0, 0}, fn {_k, v}, {twice, thrice} ->
          cond do
            v == 2 -> {1, thrice}
            v == 3 -> {twice, 1}
            true -> {twice, thrice}
          end
        end)
        {twices + twice, thrices + thrice}
      end)
    twices * thrices
  end
end

Code.require_file("test_helper.exs")

defmodule Day02Test do
  use ExUnit.Case, async: true
  import TestHelper

  @input_file "day02.input"

  describe "part 1" do
    test "abcdef" do
      assert Day02.checksum(["abcdef"]) == 0
    end

    test "bababc" do
      assert Day02.checksum(["bababc"]) == 1
    end

    test "abbcde" do
      assert Day02.checksum(["abbcde"]) == 0
    end

    test "abcccd" do
      assert Day02.checksum(["abcccd"]) == 0
    end

    test "aabcdd" do
      assert Day02.checksum(["aabcdd"]) == 0
    end

    test "abcdee" do
      assert Day02.checksum(["abcdee"]) == 0
    end

    test "ababab" do
      assert Day02.checksum(["ababab"]) == 0
    end

    test "answer" do
      answer = parse(@input_file) |> Day02.checksum
      assert answer == 6000
    end
  end

  describe "part 2" do
  end
end
