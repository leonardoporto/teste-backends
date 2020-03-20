defmodule App.Proposal.Test do
  use ExUnit.Case, async: true

  @proponents [
    %App.Proponent{ id: 1, proposal_id: 1, age: 18, monthly_income: 2500},
    %App.Proponent{ id: 2, proposal_id: 1, age: 55, monthly_income: 12500, is_main: true},
    %App.Proponent{ id: 11, proposal_id: 2, age: 18, monthly_income: 6500},
    %App.Proponent{ id: 22, proposal_id: 2, age: 72, monthly_income: 2500}
  ]

  @warranties [
    %App.Warranty{ id: 10, proposal_id: 1, value: 526362.96, province: "RJ"},
    %App.Warranty{ id: 11, proposal_id: 2, value: 526362.96, province: "PR"},
    %App.Warranty{ id: 12, proposal_id: 3, value: 126362.96, province: "SE"},
    %App.Warranty{ id: 13, proposal_id: 3, value: 26362.96, province: "PE"},
    %App.Warranty{ id: 14, proposal_id: 4, value: 126362.96, province: "PR"},
    %App.Warranty{ id: 15, proposal_id: 4, value: 60362.96, province: "SP"},
    %App.Warranty{ id: 16, proposal_id: 4, value: 60362.96, province: "RO"},
  ]

  test "should verify loan value" do
    tests = [
      %{ proposal: %App.Proposal{loan_value: 10000.00}, result:  false},
      %{ proposal: %App.Proposal{loan_value: 29999.99}, result:  false},
      %{ proposal: %App.Proposal{loan_value: 30000.00}, result:  true},
      %{ proposal: %App.Proposal{loan_value: 45000.00}, result:  true},
      %{ proposal: %App.Proposal{loan_value: 3000000.00}, result:  true},
      %{ proposal: %App.Proposal{loan_value: 3000000.01}, result:  false},
      %{ proposal: %App.Proposal{loan_value: 4000230.00}, result:  false}
    ]
    Enum.each(tests, fn test ->
      assert App.Proposal.is_valid_loan_value?(test.proposal) == test.result
    end)
  end

  test "should verify payment time" do
    tests = [
      %{ proposal: %App.Proposal{number_of_monthly_installments: 12}, result: false},
      %{ proposal: %App.Proposal{number_of_monthly_installments: 24}, result: true},
      %{ proposal: %App.Proposal{number_of_monthly_installments: 23}, result: false},
      %{ proposal: %App.Proposal{number_of_monthly_installments: 180}, result: true},
      %{ proposal: %App.Proposal{number_of_monthly_installments: 181}, result: false}
    ]
    Enum.each(tests, fn test ->
      assert App.Proposal.is_valid_payment_time?(test.proposal) == test.result
    end)
  end

  test "should check if the proposal has the minimum number of proponents" do
    tests = [
      %{ proposal: %App.Proposal{id: 99, loan_value: 45000.00, number_of_monthly_installments: 24, proponents: Enum.filter(@proponents, &(&1.proposal_id == 99))}, result: false},
      %{ proposal: %App.Proposal{id: 1, loan_value: 45000.00, number_of_monthly_installments: 48, proponents: Enum.filter(@proponents, &(&1.proposal_id == 1)) }, result: false},
      %{ proposal: %App.Proposal{id: 1, loan_value: 30000.00, number_of_monthly_installments: 48, proponents: Enum.filter(@proponents, &(&1.proposal_id == 1)) }, result: true},
      %{ proposal: %App.Proposal{id: 2, loan_value: 78000.00, number_of_monthly_installments: 180, proponents: Enum.filter(@proponents, &(&1.proposal_id == 2)) }, result: true},
      %{ proposal: %App.Proposal{id: 2, loan_value: 45000.00, number_of_monthly_installments: 48, proponents: Enum.filter(@proponents, &(&1.proposal_id == 2)) }, result: true}
    ]
    Enum.each(tests, fn test ->
      assert App.Proposal.has_min_proponents?(test.proposal) == test.result
    end)
  end

  test "should check if the proposal has only one main proponent" do
    tests = [
      %{ proposal: %App.Proposal{id: 99, loan_value: 45000.00, number_of_monthly_installments: 24, proponents: Enum.filter(@proponents, &(&1.proposal_id == 99))}, result: false},
      %{ proposal: %App.Proposal{id: 1, loan_value: 30000.00, number_of_monthly_installments: 48, proponents: Enum.filter(@proponents, &(&1.proposal_id == 1)) }, result: true},
      %{ proposal: %App.Proposal{id: 2, loan_value: 45000.00, number_of_monthly_installments: 48, proponents: Enum.filter(@proponents, &(&1.proposal_id == 2)) }, result: false}
    ]
    Enum.each(tests, fn test ->
      assert App.Proposal.has_unique_main_proponent?(test.proposal) == test.result
    end)
  end

  test "should check if the proposal has the minimum number of warranties" do
    tests = [
      %{ proposal: %App.Proposal{id: 1, loan_value: 30000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 1))}, result: true},
      %{ proposal: %App.Proposal{id: 1, loan_value: 45000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 2))}, result: false},
      %{ proposal: %App.Proposal{id: 1, loan_value: 100000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 3))}, result: true},
      %{ proposal: %App.Proposal{id: 1, loan_value: 60000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 4))}, result: true}
    ]
    Enum.each(tests, fn test ->
      assert App.Proposal.has_min_warranties?(test.proposal) == test.result
    end)
  end

  test "should checks if the sum of the warranties is valid" do
    tests = [
      %{ proposal: %App.Proposal{id: 1, loan_value: 30000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 1))}, result: true},
      %{ proposal: %App.Proposal{id: 1, loan_value: 45000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 2))}, result: false},
      %{ proposal: %App.Proposal{id: 1, loan_value: 100000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 3))}, result: true},
      %{ proposal: %App.Proposal{id: 1, loan_value: 160000.00, warranties: Enum.filter(@warranties, &(&1.proposal_id == 4))}, result: false}
    ]
    Enum.each(tests, fn test ->
      assert App.Proposal.is_valid_value_warranties?(test.proposal) == test.result
    end)
  end

end
