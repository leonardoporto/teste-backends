package cmd

import (
	"encoding/json"
	"fmt"
	"os"
)

type (
	Rules struct {
		Proposal  ProposalRule  `json:"proposal"`
		Proponent ProponentRule `json:"proponent"`
		Warranty  WarrantyRule  `json:"warranty"`
	}

	ProposalRule struct {
		Loan struct {
			Min float64 `json:"min"`
			Max float64 `json:"max"`
		} `json:"loan"`
		Duration struct {
			Min int64 `json:"min"`
			Max int64 `json:"max"`
		} `json:"duration"`
	}

	ProponentRule struct {
		Min    int   `json:"min"`
		Main   int64 `json:"main"`
		MinAge int64 `json:"minAge"`
		Income []struct {
			Min int64   `json:"min"`
			Max int64   `json:"max"`
			Mod float64 `json:"mod"`
		} `json:"income"`
	}

	WarrantyRule struct {
		Min            int      `json:"min"`
		RefuseProvince []string `json:"refuseProvince"`
		ValueMin       float64  `json:"valueMin"`
	}
)

func loadRules() (rules Rules) {
	file, err := os.Open("../config/rules.json")
	defer file.Close()
	if err != nil {
		fmt.Println("Rules not found")
	}
	data := json.NewDecoder(file)
	data.Decode(&rules)
	return
}

func (pr *ProposalRule) validate(proposal Proposal) bool {
	// O valor do empréstimo deve estar entre R$ 30.000,00 e R$ 3.000.000,00
	if !(proposal.LoanValue >= pr.Loan.Min && proposal.LoanValue <= pr.Loan.Max) {
		return false
	}
	// O empréstimo deve ser pago em no mínimo 2 anos e no máximo 15 anos
	years := proposal.NumberOfMothlyInstallments / 12
	if !(years > pr.Duration.Min && years < pr.Duration.Max) {
		return false
	}
	return true
}

func (ppr *ProponentRule) validate(proposal Proposal) bool {
	ProponentMain := []Proponent{}
	ProponentActives := []Proponent{}
	for _, pp := range proposal.Proponents {
		if pp.Status {
			// Os proponentes devem ser maiores de 18 anos
			if pp.Age >= ppr.MinAge {
				ProponentActives = append(ProponentActives, pp)
				if pp.isMain {
					ProponentMain = append(ProponentMain, pp)
				}
			}
		}
	}

	// Deve haver no mínimo 2 proponentes por proposta
	if len(ProponentActives) < ppr.Min {
		return false
	}
	// Deve haver exatamente 1 proponente principal por proposta
	if len(ProponentMain) != 1 {
		return false
	}
	// A renda do proponente principal deve ser pelo menos:
	// 4 vezes o valor da parcela do empréstimo, se a idade dele for entre 18 e 24 anos
	// 3 vezes o valor da parcela do empréstimo, se a idade dele for entre 24 e 50 anos
	// 2 vezes o valor da parcela do empréstimo, se a idade dele for acima de 50 anos
	mod := 2.0
	for _, i := range ppr.Income {
		if ProponentMain[0].Age >= i.Min && ProponentMain[0].Age < i.Max {
			mod = i.Mod
		}
	}
	installment := proposal.LoanValue / float64(proposal.NumberOfMothlyInstallments)
	total := installment * mod
	if ProponentMain[0].MonthlyIncome < total {
		return false
	}

	return true
}

func (wr *WarrantyRule) validate(proposal Proposal) bool {
	warrantyActives := []Warranty{}
	for _, w := range proposal.Warranties {
		// As garantias de imóvel dos estados PR, SC e RS não são aceitas
		if w.Status && indexOf(wr.RefuseProvince, w.Province) == -1 {
			warrantyActives = append(warrantyActives, w)
		}
	}
	// Dever haver no mínimo 1 garantia de imóvel por proposta
	if len(warrantyActives) < wr.Min {
		return false
	}
	totalWarranty := 0.0
	for _, w := range warrantyActives {
		totalWarranty += w.Value
	}
	// A soma do valor das garantias deve ser maior ou igual ao dobro do valor do empréstimo
	total := wr.ValueMin * proposal.LoanValue
	if totalWarranty < total {
		return false
	}

	return true
}

func indexOf(slice []string, value string) int {
	for k, v := range slice {
		if v == value {
			return k
		}
	}
	return -1
}
