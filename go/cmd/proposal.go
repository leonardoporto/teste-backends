package cmd

type (
	Proposal struct {
		ID                         string
		LoanValue                  float64
		NumberOfMothlyInstallments int64
		Status                     bool
		Proponents                 []Proponent
		Warranties                 []Warranty
	}

	Warranty struct {
		ID         string
		ProposalID string
		Value      float64
		Province   string
		Status     bool
	}

	Proponent struct {
		ID            string
		ProposalID    string
		Name          string
		Age           int
		MonthlyIncome int
		isMain        bool
		Status        bool
	}
)

func (p *Proposal) update(proposal Proposal) {
	p.LoanValue = proposal.LoanValue
	p.NumberOfMothlyInstallments = proposal.NumberOfMothlyInstallments
}

func (p *Proposal) delete() {}

func (p *Proposal) warrantyAdd() {}

func (p *Proposal) warrantyUpdate() {}

func (p *Proposal) warrantyRemove() {}

func (p *Proposal) proponentAdd() {}

func (p *Proposal) proponentUpdate() {}

func (p *Proposal) proponentRemove() {}
