defmodule Day01 do
  def final_frequency(changes) do
    Enum.reduce(changes, 0, fn change, acc ->
      acc + change
    end)
  end

  def first_duplicate(changes) do
    first_duplicate(changes, %{0 => 1}, 0)
  end

  defp first_duplicate(changes, initial_counts, initial_frequency) do
    {counts, current_frequency} =
      Enum.reduce_while(changes, {initial_counts, initial_frequency}, fn change, {counts, current_frequency} ->
        next_frequncy = current_frequency + change
        new_counts = Map.update(counts, next_frequncy, 1, &(&1 + 1))
        acc = {new_counts, next_frequncy}
        if Map.get(new_counts, next_frequncy, 0) > 1 do
          {:halt, acc}
        else
          {:cont, acc}
        end
      end)
    case Enum.find(counts, fn {_frequency, count} -> count > 1 end) do
      {first_duplicate_frequency, _count} ->
        first_duplicate_frequency
      nil ->
        first_duplicate(changes, counts, current_frequency)
    end
  end
end

ExUnit.start()

defmodule Day01Test do
  use ExUnit.Case, async: true

  @input_file "day01.input"

  def parse(file) do
    File.read!(file)
    |> String.split
    |> Enum.map(&String.to_integer/1)
  end

  describe "part 1" do
    test "+1, -2, +3, +1" do
      assert Day01.final_frequency([+1, -2, +3, +1]) == 3
    end

    test "+1, +1, +1" do
      assert Day01.final_frequency([+1, +1, +1]) == 3
    end

    test "+1, +1, -2" do
      assert Day01.final_frequency([+1, +1, -2]) == 0
    end

    test "-1, -2, -3" do
      assert Day01.final_frequency([-1, -2, -3]) == -6
    end

    test "answer" do
      answer = parse(@input_file)
      |> Day01.final_frequency
      # |> IO.inspect(label: "Part 1 Answer")
      assert answer == 406
    end
  end

  describe "part 2" do
    test "+1, -2, +3, +1" do
      assert Day01.first_duplicate([+1, -2, +3, +1]) == 2
    end

    test "+1, -1" do
      assert Day01.first_duplicate([+1, -1]) == 0
    end

    test "+3, +3, +4, -2, -4" do
      assert Day01.first_duplicate([+3, +3, +4, -2, -4]) == 10
    end

    test "-6, +3, +8, +5, -6" do
      assert Day01.first_duplicate([-6, +3, +8, +5, -6]) == 5
    end

    test "+7, +7, -2, -7, -4" do
      assert Day01.first_duplicate([+7, +7, -2, -7, -4]) == 14
    end

    test "answer" do
      answer = parse(@input_file)
      |> Day01.first_duplicate
      # |> IO.inspect(label: "Part 2 Answer")
      assert answer == 312
    end
  end
end
