defmodule Analyzer.Proposal do
  @moduledoc """
   Responsible for proposal control
  """
  defstruct id: nil, loan_value: nil, number_of_monthly_installments: nil, warranties: [], proponents: []

  alias Analyzer.Proponent
  alias Analyzer.Warranty

  def make_proposal(proposal, event) do
    [proposal, event]
  end

  def is_valid_loan_value?(%{loan_value: value}) when is_float(value) do
    30_000.00 <= value and value <= 3_000_000.00
  end

  def is_valid_payment_time?(%{number_of_monthly_installments: total}) when is_integer(total) do
    years = total / 12
    2 <= years and years <= 15
  end

  def has_min_proponents?(%{proponents: proponents} = proposal) when is_list(proponents) do
    qtd_active = proponents
      |> Enum.filter(&(Proponent.is_valid?(&1, installment_caculate(proposal))))
      |> Enum.count
    qtd_active >= 2
  end

  def has_unique_main_proponent?(%{proponents: proponents} = proposal) when is_list(proponents) do
    qtd_main_proponent = proponents
      |> Enum.filter(&(Proponent.is_valid?(&1, installment_caculate(proposal))))
      |> Enum.filter(&(&1.is_main))
      |> Enum.count
    qtd_main_proponent == 1
  end

  def has_min_warranties?(%{warranties: warranties}) when is_list(warranties) do
    qtd = warranties
      |> Enum.filter(&(Warranty.is_valid?(&1)))
      |> Enum.count
    qtd >= 1
  end

  def is_valid_value_warranties?(%{warranties: warranties} = proposal) when is_list(warranties) do
    warranty_total = warranties
      |> Enum.filter(&(Warranty.is_valid?(&1)))
      |> Enum.map(&(&1.value))
      |> Enum.sum
    warranty_total >= proposal.loan_value
  end

  defp installment_caculate(%{loan_value: value, number_of_monthly_installments: months}) do
    value / months
  end

end
