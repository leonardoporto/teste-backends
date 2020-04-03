defmodule Analyzer.Warranty.Test do
  use ExUnit.Case, async: true

  alias Analyzer.Warranty

  test "should verify that a province is valid" do
    tests = [
      %{warranty: %Warranty{province: "AM"}, result: true},
      %{warranty: %Warranty{province: "PR"}, result: false},
      %{warranty: %Warranty{province: "RJ"}, result: true},
      %{warranty: %Warranty{province: "ES"}, result: true},
      %{warranty: %Warranty{province: "RS"}, result: false}
    ]

    Enum.each(tests, fn test ->
      assert Warranty.is_valid_province?(test.warranty) == test.result
    end)
  end
end
