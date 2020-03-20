defmodule App.Event do
  defstruct id: nil, type: nil, action: nil, date: nil, data: []

  def new(line) do

    { [id, type, action, date], data } = line
      |> String.split(",")
      |> Enum.split(4)

    %App.Event{
        id: id,
        type: type,
        action: action,
        date: date,
        data: data
      }
  end

  def parser_data(%App.Event{data: data}) when length(data) == 1 do
    [id] = data
    id
  end

  def parser_data(%App.Event{data: data}) when length(data) == 2 do
    [id_proposal, id] = data
    %{
      id_proposal: id_proposal,
      id: id
    }
  end

  def parser_data(%App.Event{data: data}) when length(data) == 3 do
    [id, loan_value, number_of_monthly_installments] = data
    %App.Proposal{
      id: id,
      loan_value: loan_value,
      number_of_monthly_installments: number_of_monthly_installments
    }
  end

  def parser_data(%App.Event{data: data}) when length(data) == 4 do
    [proposal_id, id, value, province] = data
    %App.Warranty{
      proposal_id: proposal_id,
      id: id,
      value: value,
      province: province
    }
  end

  def parser_data(%App.Event{data: data}) when length(data) == 6 do
    [proposal_id, id, name, age, monthly_income, is_main] = data
    %App.Proponent{
      proposal_id: proposal_id,
      id: id,
      name: name,
      age: age,
      monthly_income: monthly_income,
      is_main: is_main
    }
  end

end
