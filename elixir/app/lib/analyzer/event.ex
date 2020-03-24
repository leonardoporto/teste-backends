defmodule Analyzer.Event do
  @moduledoc """
   Responsible for event control
  """
  defstruct id: nil, type: nil, action: nil, date: nil, data: []

  alias Analyzer.Proposal
  alias Analyzer.Proponent
  alias Analyzer.Warranty

  def receive(line) do

    {[id, type, action, date], data} = line
      |> String.split(",")
      |> Enum.split(4)

    {:ok, datetime, _} = DateTime.from_iso8601(date)

    %{
        id: id,
        type: type,
        action: action,
        date: datetime,
        data: process_data(data)
      }
  end

  def process_data([id | tail]) when tail == [], do: id # remove proposal

  def process_data([id_proposal, id | tail]) when tail == [], do: %{id_proposal: id_proposal, id: id} # remove from proposal

  def process_data(data) when length(data) == 3 do # create and update proposal
    [id, loan_value, number_of_monthly_installments] = data
    %Proposal{
      id: id,
      loan_value: String.to_float(loan_value),
      number_of_monthly_installments: String.to_integer(number_of_monthly_installments)
    }
  end

  def process_data(data) when length(data) == 4 do # create and update warranty
    [proposal_id, id, value, province] = data
    %Warranty{
      proposal_id: proposal_id,
      id: id,
      value: String.to_float(value),
      province: province
    }
  end

  def process_data(data) when length(data) == 6 do # create and update proponent
    [proposal_id, id, name, age, monthly_income, is_main] = data
    %Proponent{
      proposal_id: proposal_id,
      id: id,
      name: name,
      age: String.to_integer(age),
      monthly_income: String.to_float(monthly_income),
      is_main: String.to_existing_atom(is_main)
    }
  end

end
