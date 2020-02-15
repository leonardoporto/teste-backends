package cmd

var base Proposal

func init() {
	base = Proposal{
		ID:                         "teste",
		LoanValue:                  229657.0,
		NumberOfMothlyInstallments: 24,
	}
}
