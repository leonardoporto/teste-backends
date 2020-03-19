defmodule App.Proponent do
  defstruct id: nil, proposal_id: nil, name: nil, age: nil, monthly_income: nil, is_main: false

  def is_valid?(proponent, installment) do
    check_min_age(proponent) and check_income(proponent, installment)
  end

  def check_min_age(proponent) do
    proponent.age >= 18
  end

  def check_income(proponent, installment) do
    installment * define_mod(proponent.age) <= proponent.monthly_income
  end

  def define_mod(age) do
    cond do
      Enum.member?(18..23, age) -> 4
      Enum.member?(24..49, age) -> 3
      Enum.member?(50..120, age) -> 2
    end
  end
end
L
