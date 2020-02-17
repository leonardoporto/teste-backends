package cmd

import (
	"os"
	"strconv"
	"strings"
)

type (
	// Rules Base Business Rule
	Rules struct {
		Proposal  ProposalRule  `json:"proposal"`
		Proponent ProponentRule `json:"proponent"`
		Warranty  WarrantyRule  `json:"warranty"`
	}
	// ProposalRule Business Rule Proposal
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
	// ProponentRule Business Rule Proponent
	ProponentRule struct {
		Min    int      `json:"min"`
		Main   int64    `json:"main"`
		MinAge int64    `json:"minAge"`
		Income []Income `json:"income"`
	}
	// WarrantyRule Business Rule Warranty
	WarrantyRule struct {
		Min            int      `json:"min"`
		RefuseProvince []string `json:"refuseProvince"`
		ValueMin       float64  `json:"valueMin"`
	}
	// Income - Income data
	Income struct {
		Min int64   `json:"min"`
		Max int64   `json:"max"`
		Mod float64 `json:"mod"`
	}
)

// LoadRules - responsible for loading the business rules
func LoadRules() (rules Rules) {
	proposalLoanMin, err := strconv.ParseFloat(os.Getenv("proposalLoanMin"), 64)
	if err != nil {
		proposalLoanMin = 30000.0
	}
	rules.Proposal.Loan.Min = proposalLoanMin

	proposalLoanMax, err := strconv.ParseFloat(os.Getenv("proposalLoanMax"), 64)
	if err != nil {
		proposalLoanMax = 3000000.0
	}
	rules.Proposal.Loan.Max = proposalLoanMax

	proposalDurationMin, err := strconv.ParseInt(os.Getenv("proposalDurationMin"), 10, 64)
	if err != nil {
		proposalDurationMin = 2
	}
	rules.Proposal.Duration.Min = proposalDurationMin

	proposalDurationMax, err := strconv.ParseInt(os.Getenv("proposalDurationMax"), 10, 64)
	if err != nil {
		proposalDurationMax = 15
	}
	rules.Proposal.Duration.Max = proposalDurationMax

	warrantyMin, err := strconv.Atoi(os.Getenv("warrantyMin"))
	if err != nil {
		warrantyMin = 1
	}
	rules.Warranty.Min = warrantyMin

	warrantyValueMin, err := strconv.ParseFloat(os.Getenv("warrantyValueMin"), 64)
	if err != nil {
		warrantyValueMin = 2.0
	}
	rules.Warranty.ValueMin = warrantyValueMin

	warrantyRefuseProvince := os.Getenv("warrantyRefuseProvince")
	if warrantyRefuseProvince == "" {
		warrantyRefuseProvince = "PR,SC,RS"
	}
	rules.Warranty.RefuseProvince = strings.Split(warrantyRefuseProvince, ",")

	proponentMin, err := strconv.Atoi(os.Getenv("proponentMin"))
	if err != nil {
		proponentMin = 2
	}
	rules.Proponent.Min = proponentMin

	proponentMain, err := strconv.ParseInt(os.Getenv("proponentMain"), 10, 64)
	if err != nil {
		proponentMain = 1
	}
	rules.Proponent.Main = proponentMain

	proponentMinAge, err := strconv.ParseInt(os.Getenv("proponentMinAge"), 10, 64)
	if err != nil {
		proponentMinAge = 18
	}
	rules.Proponent.MinAge = proponentMinAge

	proponentIncome1824, err := strconv.ParseFloat(os.Getenv("proponentIncome1824"), 64)
	if err != nil {
		proponentIncome1824 = 4.0
	}
	proponentIncome2450, err := strconv.ParseFloat(os.Getenv("proponentIncome2450"), 64)
	if err != nil {
		proponentIncome2450 = 3.0
	}
	proponentIncome50, err := strconv.ParseFloat(os.Getenv("proponentIncome50"), 64)
	if err != nil {
		proponentIncome50 = 2.0
	}

	rules.Proponent.Income = append(rules.Proponent.Income, Income{18, 24, proponentIncome1824})
	rules.Proponent.Income = append(rules.Proponent.Income, Income{24, 50, proponentIncome2450})
	rules.Proponent.Income = append(rules.Proponent.Income, Income{50, 150, proponentIncome50})

	return
}

func (pr *ProposalRule) validate(proposal Proposal) bool {
	// O valor do empréstimo deve estar entre R$ 30.000,00 e R$ 3.000.000,00
	if !(proposal.LoanValue >= pr.Loan.Min && proposal.LoanValue <= pr.Loan.Max) {
		return false
	}
	// O empréstimo deve ser pago em no mínimo 2 anos e no máximo 15 anos
	years := proposal.NumberOfMothlyInstallments / 12
	if !(years >= pr.Duration.Min && years <= pr.Duration.Max) {
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
