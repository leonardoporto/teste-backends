package cmd

import "testing"

var base Proposal

func init() {
	base = Proposal{
		ID:                         "teste",
		LoanValue:                  229657.0,
		NumberOfMothlyInstallments: 24,
	}
}

func TestProposalUpdate(t *testing.T) {

	tests := []struct {
		name string
		in   string
		out  Proposal
	}{
		{
			"Proposal / Alter values",
			"update",
			Proposal{
				LoanValue:                  9657.0,
				NumberOfMothlyInstallments: 12,
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			base.update(tt.out)
			if base.LoanValue != tt.out.LoanValue || base.NumberOfMothlyInstallments != tt.out.NumberOfMothlyInstallments {
				t.Errorf("errro")
			}
		})
	}
}
