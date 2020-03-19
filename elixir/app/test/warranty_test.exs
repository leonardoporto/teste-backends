defmodule App.Warranty.Test do
  use ExUnit.Case, async: true

  test "should verify that a province is valid" do
    tests = [
      %{warranty: %App.Warranty{province: "AM"}, result: true },
      %{warranty: %App.Warranty{province: "PR"}, result: false },
      %{warranty: %App.Warranty{province: "RJ"}, result: true },
      %{warranty: %App.Warranty{province: "ES"}, result: true },
      %{warranty: %App.Warranty{province: "RS"}, result: false },
    ]
    Enum.each(tests, fn test ->
      assert App.Warranty.is_valid_province?(test.warranty) == test.result
    end)
  end
end
