defmodule App.Proponent.Test do
  use ExUnit.Case, async: true

  test "should verify proponent age - age lower 18" do
    proponent = %App.Proponent{name: "Adamastor Jr", age: 17}
    assert App.Proponent.check_min_age(proponent) == false
  end

  test "should verify proponent age - age greater 18" do
    proponent = %App.Proponent{name: "Adamastor Jr", age: 18}
    assert App.Proponent.check_min_age(proponent) == true
  end

  test "should return the modifier according to the age of the proponent" do
    tests = [
      %{age: 18, result: 4},
      %{age: 24, result: 3},
      %{age: 50, result: 2}
    ]
    Enum.each(tests, fn test ->
      assert App.Proponent.define_mod(test.age) == test.result
    end)
  end

  test "should verify that the monthly income is higher than installment" do
    tests = [
      %{proponent: %App.Proponent{name: "Julio Neto", age: 18, monthly_income: 1500}, installment: 500, result: false},
      %{proponent: %App.Proponent{name: "Julio Jr", age: 42, monthly_income: 2000}, installment: 800, result: false},
      %{proponent: %App.Proponent{name: "Julio", age: 75, monthly_income: 1500}, installment: 1500, result: false},
      %{proponent: %App.Proponent{name: "Julio Neto", age: 18, monthly_income: 2500}, installment: 500, result: true},
      %{proponent: %App.Proponent{name: "Julio Jr", age: 42, monthly_income: 2600}, installment: 800, result: true},
      %{proponent: %App.Proponent{name: "Julio", age: 75, monthly_income: 2400}, installment: 1100, result: true}
    ]
    Enum.each(tests, fn test ->
      assert App.Proponent.check_income(test.proponent, test.installment) == test.result
    end)
  end

end
