package cmd

import (
	"testing"
)

func TestValidateProposal(t *testing.T) {

	rules := LoadRules("../config/rules.json")

	tests := []struct {
		name string
		in   Proposal
		out  bool
	}{
		{"Lower value", Proposal{LoanValue: 25000.00, NumberOfMothlyInstallments: 36}, false},
		{"Lower number of installments", Proposal{LoanValue: 36000.00, NumberOfMothlyInstallments: 12}, false},
		{"Value Ok and Installments Ok", Proposal{LoanValue: 36000.00, NumberOfMothlyInstallments: 36}, true},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := rules.Proposal.validate(tt.in)
			if result != tt.out {
				t.Errorf("failed %q, expeted %v and return %v", tt.name, tt.out, result)
			}
		})
	}
}

func TestValidateWarranty(t *testing.T) {
	rules := LoadRules("../config/rules.json")

	warranties := []Warranty{
		Warranty{Province: "SC", Value: 90000.00, Status: true},
		Warranty{Province: "SP", Value: 25000.00, Status: true},
		Warranty{Province: "RJ", Value: 250000.00, Status: true},
		Warranty{Province: "PR", Value: 250000.00, Status: true},
		Warranty{Province: "RJ", Value: 250000.00, Status: false},
	}

	tests := []struct {
		name string
		in   Proposal
		out  bool
	}{
		{"Only one warranty and province SC", Proposal{Warranties: map[string]Warranty{"1": warranties[0]}}, false},
		{"Two warranties(one is province PR), Loan 500k and total warranty is 250k", Proposal{LoanValue: 500000, Warranties: map[string]Warranty{"4": warranties[3], "3": warranties[2]}}, false},
		{"Two warranties and one is province PR and Loan 100k", Proposal{LoanValue: 100000, Warranties: map[string]Warranty{"4": warranties[3], "3": warranties[2]}}, true},
		{"No warranty valid", Proposal{LoanValue: 100000, Warranties: map[string]Warranty{"1": warranties[0], "4": warranties[3], "5": warranties[4]}}, false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := rules.Warranty.validate(tt.in)
			if result != tt.out {
				t.Errorf("failed %q, expeted %v and return %v", tt.name, tt.out, result)
			}
		})
	}
}

func TestValidateProponent(t *testing.T) {

	rules := LoadRules("../config/rules.json")

	proponents := []Proponent{
		{Age: 16, MonthlyIncome: 10000.0, isMain: true, Status: true},  //0
		{Age: 16, MonthlyIncome: 10000.0, isMain: false, Status: true}, //1
		{Age: 18, MonthlyIncome: 2510.0, isMain: false, Status: true},  //2
		{Age: 61, MonthlyIncome: 12563.9, isMain: true, Status: true},  //3
		{Age: 27, MonthlyIncome: 2500.0, isMain: false, Status: true},  //4
		{Age: 34, MonthlyIncome: 7500.0, isMain: true, Status: true},   //5
		{Age: 23, MonthlyIncome: 4500.0, isMain: true, Status: true},   //6
	}

	tests := []struct {
		name string
		in   Proposal
		out  bool
	}{
		{"Proponent under the age of 18", Proposal{Proponents: map[string]Proponent{"1": proponents[0], "2": proponents[1]}}, false},
		{"Proponent under the age of 18 is main", Proposal{Proponents: map[string]Proponent{"1": proponents[0], "2": proponents[2]}}, false},
		{"No exists main proponent", Proposal{Proponents: map[string]Proponent{"2": proponents[2], "3": proponents[4]}}, false},
		{"Main bidder's(>50 age) income below the value of the installments", Proposal{LoanValue: 1000000, NumberOfMothlyInstallments: 12, Proponents: map[string]Proponent{"1": proponents[3], "2": proponents[4]}}, false},
		{"Main bidder's(>50 age) income above the value of the installments", Proposal{LoanValue: 100000, NumberOfMothlyInstallments: 50, Proponents: map[string]Proponent{"1": proponents[3], "2": proponents[4]}}, true},
		{"Main bidder's(24~50 age) income below the value of the installments", Proposal{LoanValue: 1000000, NumberOfMothlyInstallments: 12, Proponents: map[string]Proponent{"1": proponents[4], "2": proponents[5]}}, false},
		{"Main bidder's(24~50 age) income above the value of the installments", Proposal{LoanValue: 10000, NumberOfMothlyInstallments: 50, Proponents: map[string]Proponent{"1": proponents[4], "2": proponents[5]}}, true},
		{"Main bidder's(18~24 age) income below the value of the installments", Proposal{LoanValue: 1000000, NumberOfMothlyInstallments: 12, Proponents: map[string]Proponent{"1": proponents[4], "2": proponents[6]}}, false},
		{"Main bidder's(18~24 age) income above the value of the installments", Proposal{LoanValue: 10000, NumberOfMothlyInstallments: 50, Proponents: map[string]Proponent{"1": proponents[4], "2": proponents[6]}}, true},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := rules.Proponent.validate(tt.in)
			if result != tt.out {
				t.Errorf("failed %q, expeted %v and return %v", tt.name, tt.out, result)
			}
		})
	}
}
