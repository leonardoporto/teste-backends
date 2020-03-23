defmodule App.Event do
  defstruct id: nil, type: nil, action: nil, date: nil, data: []

  def new(line) do

    { [id, type, action, date], data } = line
      |> String.split(",")
      |> Enum.split(4)

    {:ok, datetime, _} = DateTime.from_iso8601(date)

    %App.Event{
        id: id,
        type: type,
        action: action,
        date: datetime,
        data: data
      }
  end

  def parser_data(%App.Event{data: data}) when length(data) == 1 do # remove proposal
    [id] = data
    id
  end

  def parser_data(%App.Event{data: data}) when length(data) == 2 do # remove from proposal
    [id_proposal, id] = data
    %{
      id_proposal: id_proposal,
      id: id
    }
  end

  def parser_data(%App.Event{data: data, action: action}) when length(data) == 3 and action == "created" do # create and update proposal
    [id, loan_value, number_of_monthly_installments] = data
    %App.Proposal{
      id: id,
      loan_value: String.to_float(loan_value),
      number_of_monthly_installments: String.to_integer(number_of_monthly_installments)
    }
  end

  def parser_data(%App.Event{data: data, action: action}) when length(data) == 3 and action == "updated"  do # create and update proposal
    [id, loan_value, number_of_monthly_installments] = data
    %{
      id: id,
      loan_value: String.to_float(loan_value),
      number_of_monthly_installments: String.to_integer(number_of_monthly_installments)
    }
  end

  def parser_data(%App.Event{data: data}) when length(data) == 4 do
    [proposal_id, id, value, province] = data
    %App.Warranty{
      proposal_id: proposal_id,
      id: id,
      value: String.to_float(value),
      province: province
    }
  end

  def parser_data(%App.Event{data: data}) when length(data) == 6 do
    [proposal_id, id, name, age, monthly_income, is_main] = data
    %App.Proponent{
      proposal_id: proposal_id,
      id: id,
      name: name,
      age: String.to_integer(age),
      monthly_income: String.to_float(monthly_income),
      is_main: String.to_existing_atom(is_main)
    }
  end

end
