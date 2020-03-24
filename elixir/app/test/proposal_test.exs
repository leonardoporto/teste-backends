defmodule Analyzer.Proposal.Test do
  use ExUnit.Case, async: true

  alias Analyzer.Proponent
  alias Analyzer.Warranty
  alias Analyzer.Proposal

  @proponents [
    %Proponent{id: 1, proposal_id: 1, age: 18, monthly_income: 2_500},
    %Proponent{id: 2, proposal_id: 1, age: 55, monthly_income: 12_500, is_main: true},
    %Proponent{id: 11, proposal_id: 2, age: 18, monthly_income: 6_500},
    %Proponent{id: 22, proposal_id: 2, age: 72, monthly_income: 2_500}
  ]

  @warranties [
    %Warranty{id: 10, proposal_id: 1, value: 526_362.96, province: "RJ"},
    %Warranty{id: 11, proposal_id: 2, value: 526_362.96, province: "PR"},
    %Warranty{id: 12, proposal_id: 3, value: 126_362.96, province: "SE"},
    %Warranty{id: 13, proposal_id: 3, value: 26_362.96, province: "PE"},
    %Warranty{id: 14, proposal_id: 4, value: 126_362.96, province: "PR"},
    %Warranty{id: 15, proposal_id: 4, value: 60_362.96, province: "SP"},
    %Warranty{id: 16, proposal_id: 4, value: 60_362.96, province: "RO"},
  ]


  test "should verify loan value" do
    tests = [
      %{proposal: %Proposal{loan_value: 10_000.00}, result:  false},
      %{proposal: %Proposal{loan_value: 29_999.99}, result:  false},
      %{proposal: %Proposal{loan_value: 30_000.00}, result:  true},
      %{proposal: %Proposal{loan_value: 45_000.00}, result:  true},
      %{proposal: %Proposal{loan_value: 3_000_000.00}, result:  true},
      %{proposal: %Proposal{loan_value: 3_000_000.01}, result:  false},
      %{proposal: %Proposal{loan_value: 4_000_230.00}, result:  false}
    ]
    Enum.each(tests, fn test ->
      assert Proposal.is_valid_loan_value?(test.proposal) == test.result
    end)
  end

  test "should verify payment time" do
    tests = [
      %{proposal: %Proposal{number_of_monthly_installments: 12}, result: false},
      %{proposal: %Proposal{number_of_monthly_installments: 24}, result: true},
      %{proposal: %Proposal{number_of_monthly_installments: 23}, result: false},
      %{proposal: %Proposal{number_of_monthly_installments: 180}, result: true},
      %{proposal: %Proposal{number_of_monthly_installments: 181}, result: false}
    ]
    Enum.each(tests, fn test ->
      assert Proposal.is_valid_payment_time?(test.proposal) == test.result
    end)
  end

  test "should check if the proposal has the minimum number of proponents" do
    tests = [
      %{proposal: %Proposal{id: 99, loan_value: 45_000.00, number_of_monthly_installments: 24, proponents: Enum.filter(@proponents, &(&1.proposal_id == 99))}, result: false},
      %{proposal: %Proposal{id: 1, loan_value: 45_000.00, number_of_monthly_installments: 48, proponents: Enum.filter(@proponents, &(&1.proposal_id == 1)) }, result: false},
      %{proposal: %Proposal{id: 1, loan_value: 30_000.00, number_of_monthly_installments: 48, proponents: Enum.filter(@proponents, &(&1.proposal_id == 1)) }, result: true},
      %{proposal: %Proposal{id: 2, loan_value: 78_000.00, number_of_monthly_installments: 180, proponents: Enum.filter(@proponents, &(&1.proposal_id == 2)) }, result: true},
      %{proposal: %Proposal{id: 2, loan_value: 45_000.00, number_of_monthly_installments: 48, proponents: Enum.filter(@proponents, &(&1.proposal_id == 2)) }, result: true}
    ]
    Enum.each(tests, fn test ->
      assert Proposal.has_min_proponents?(test.proposal) == test.result
    end)
  end

  test "should check if the proposal has only one main proponent" do
    tests = [
      %{proposal: %Proposal{id: 99, loan_value: 45_000.00, number_of_monthly_installments: 24, proponents: Enum.filter(@proponents, &(&1.proposal_id == 99))}, result: false},
      %{proposal: %Proposal{id: 1, loan_value: 30_000.00, number_of_monthly_installments: 48, proponents: Enum.filter(@proponents, &(&1.proposal_id == 1)) }, result: true},
      %{proposal: %Proposal{id: 2, loan_value: 45_000.00, number_of_monthly_installments: 48, proponents: Enum.filter(@proponents, &(&1.proposal_id == 2)) }, result: false}
    ]
    Enum.each(tests, fn test ->
      assert Proposal.has_unique_main_proponent?(test.proposal) == test.result
    end)
  end

  test "should check if the proposal has the minimum number of warranties" do
    tests = [
      %{proposal: %Proposal{id: 1, loan_value: 30_000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 1))}, result: true},
      %{proposal: %Proposal{id: 1, loan_value: 45_000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 2))}, result: false},
      %{proposal: %Proposal{id: 1, loan_value: 100_000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 3))}, result: true},
      %{proposal: %Proposal{id: 1, loan_value: 60_000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 4))}, result: true}
    ]
    Enum.each(tests, fn test ->
      assert Proposal.has_min_warranties?(test.proposal) == test.result
    end)
  end

  test "should checks if the sum of the warranties is valid" do
    tests = [
      %{proposal: %Proposal{id: 1, loan_value: 30_000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 1))}, result: true},
      %{proposal: %Proposal{id: 1, loan_value: 45_000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 2))}, result: false},
      %{proposal: %Proposal{id: 1, loan_value: 100_000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 3))}, result: true},
      %{proposal: %Proposal{id: 1, loan_value: 160_000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 4))}, result: false}
    ]
    Enum.each(tests, fn test ->
      assert Proposal.is_valid_value_warranties?(test.proposal) == test.result
    end)
  end

end
