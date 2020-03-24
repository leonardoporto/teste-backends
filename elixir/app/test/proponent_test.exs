defmodule Analyzer.Proponent.Test do
  use ExUnit.Case, async: true

  alias Analyzer.Proponent

  test "should verify proponent age - age lower 18" do
    proponent = %Proponent{name: "Adamastor Jr", age: 17}
    assert Proponent.has_minimum_age?(proponent) == false
  end

  test "should verify proponent age - age greater 18" do
    proponent = %Proponent{name: "Adamastor Jr", age: 18}
    assert Proponent.has_minimum_age?(proponent) == true
  end

  test "should verify that the monthly income is higher than installment" do
    tests = [
      %{
        proponent: %Proponent{name: "Julio Neto", age: 18, monthly_income: 1500},
        installment: 500,
        result: false
      },
      %{
        proponent: %Proponent{name: "Julio Jr", age: 42, monthly_income: 2000},
        installment: 800,
        result: false
      },
      %{
        proponent: %Proponent{name: "Julio", age: 75, monthly_income: 1500},
        installment: 1500,
        result: false
      },
      %{
        proponent: %Proponent{name: "Julio Neto", age: 18, monthly_income: 2500},
        installment: 500,
        result: true
      },
      %{
        proponent: %Proponent{name: "Julio Jr", age: 42, monthly_income: 2600},
        installment: 800,
        result: true
      },
      %{
        proponent: %Proponent{name: "Julio", age: 75, monthly_income: 2400},
        installment: 1100,
        result: true
      }
    ]

    Enum.each(tests, fn test ->
      assert Proponent.has_minimum_income?(test.proponent, test.installment) == test.result
    end)
  end
end
