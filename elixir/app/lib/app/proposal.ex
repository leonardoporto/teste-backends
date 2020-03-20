defmodule App.Proposal do

  defstruct id: nil, loan_value: nil, number_of_monthly_installments: nil, warranties: [], proponents: []

  def is_valid_loan_value?(%App.Proposal{loan_value: value}) when is_float(value) do
    30000.00 <= value and value <= 3000000.00
  end

  def is_valid_payment_time?(%App.Proposal{number_of_monthly_installments: total}) when is_integer(total) do
    years = total / 12
    2 <= years and years <= 15
  end

  def has_min_proponents?(%App.Proposal{proponents: proponents} = proposal) when is_list(proponents) do
    qtd_active = proponents
      |> Enum.filter(&(App.Proponent.is_valid?(&1, installment_caculate(proposal))))
      |> Enum.count
    qtd_active >= 2
  end

  def has_unique_main_proponent?(%App.Proposal{proponents: proponents} = proposal) when is_list(proponents) do
    qtd_main_proponent = proponents
      |> Enum.filter(&(App.Proponent.is_valid?(&1, installment_caculate(proposal))))
      |> Enum.filter(&(&1.is_main))
      |> Enum.count
    qtd_main_proponent == 1
  end

  def has_min_warranties?(%App.Proposal{warranties: warranties}) when is_list(warranties) do
    qtd = warranties
      |> Enum.filter(&(App.Warranty.is_valid(&1)))
      |> Enum.count
    qtd >=1
  end

  def is_valid_value_warranties?(%App.Proposal{warranties: warranties} = proposal) when is_list(warranties) do
    warranty_total = warranties
      |> Enum.filter(&(App.Warranty.is_valid(&1)))
      |> Enum.map(&(&1.value))
      |> Enum.sum
    warranty_total >= proposal.loan_value
  end

  defp installment_caculate(%App.Proposal{loan_value: value, number_of_monthly_installments: months}) do
    value / months
  end

end
