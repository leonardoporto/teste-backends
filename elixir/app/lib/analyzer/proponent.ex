defmodule Analyzer.Proponent do
  @moduledoc """
   Responsible for Proponent rules
  """
  defstruct id: nil, proposal_id: nil, name: nil, age: nil, monthly_income: nil, is_main: false

  def is_valid?(proponent, installment) do
    has_minimum_age?(proponent) and has_minimum_income?(proponent, installment)
  end

  def has_minimum_age?(proponent) do
    proponent.age >= 18
  end

  def has_minimum_income?(proponent, installment) do
    installment * define_mod(proponent.age) <= proponent.monthly_income
  end

  defp define_mod(age) do
    cond do
      Enum.member?(18..23, age) -> 4
      Enum.member?(24..49, age) -> 3
      Enum.member?(50..120, age) -> 2
    end
  end
end
L
