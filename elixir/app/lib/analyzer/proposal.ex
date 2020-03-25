defmodule Analyzer.Proposal do
  @moduledoc """
   Responsible for proposal control
  """

  defstruct id: nil,
            loan_value: nil,
            number_of_monthly_installments: nil,
            warranties: %{},
            proponents: %{}

  alias Analyzer.Proponent
  alias Analyzer.Warranty

  def is_valid?({id, proposal}) do
    with true <- is_valid_loan_value?(proposal),
         true <- is_valid_payment_time?(proposal),
         true <- has_min_proponents?(proposal),
         true <- has_unique_main_proponent?(proposal),
         true <- has_min_warranties?(proposal),
         true <- is_valid_value_warranties?(proposal) do
      {:is_valid, id}
    else
      false -> {:is_invalid}
    end
  end

  def is_valid_loan_value?(%{loan_value: value}) when is_float(value) do
    30_000.00 <= value and value <= 3_000_000.00
  end

  def is_valid_payment_time?(%{number_of_monthly_installments: total}) when is_integer(total) do
    years = total / 12
    2 <= years and years <= 15
  end

  def has_min_proponents?(%{proponents: proponents} = proposal) when is_map(proponents) do
    qtd_active =
      proponents
      |> Enum.filter(fn {_id, proponent} ->
        Proponent.is_valid?(proponent, installment_caculate(proposal))
      end)
      |> Enum.count()

    qtd_active >= 2
  end

  def has_unique_main_proponent?(%{proponents: proponents} = proposal) when is_map(proponents) do
    qtd_main_proponent =
      proponents
      |> Enum.filter(fn {_id, proponent} ->
        Proponent.is_valid?(proponent, installment_caculate(proposal))
      end)
      |> Enum.filter(fn {_id, proponent} -> proponent.is_main end)
      |> Enum.count()

    qtd_main_proponent == 1
  end

  def has_min_warranties?(%{warranties: warranties}) when is_map(warranties) do
    qtd =
      warranties
      |> Enum.filter(fn {_id, warranty} ->
        Warranty.is_valid?(warranty)
      end)
      |> Enum.count()

    qtd >= 1
  end

  def is_valid_value_warranties?(%{warranties: warranties} = proposal) when is_map(warranties) do
    warranty_total =
      warranties
      |> Enum.filter(fn {_id, warranty} ->
        Warranty.is_valid?(warranty)
      end)
      |> Enum.map(fn {_id, warranty} ->
        warranty.value
      end)
      |> Enum.sum()

    warranty_total >= proposal.loan_value * 2
  end

  defp installment_caculate(%{loan_value: value, number_of_monthly_installments: months}) do
    value / months
  end
end
