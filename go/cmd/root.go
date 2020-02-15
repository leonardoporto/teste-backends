package cmd

import (
	"fmt"
	"strings"
)

func Execute(path string) {
	// damos load no arquivo
	lines := parser(path)
	// convertemos linhas em propostas
	proposals := convert2Proposal(lines)
	// inicia validacao
	result := check(proposals)
	fmt.Println(strings.Join(result, ","))
}

func check(proposals map[string]Proposal) (ids []string) {
	//load rules
	rules := loadRules()
	for id, p := range proposals {
		results := []bool{}
		results = append(results, rules.Proposal.validate(p))
		results = append(results, rules.Warranty.validate(p))
		results = append(results, rules.Proponent.validate(p))
		fmt.Println(results)
		if validate(results) {
			ids = append(ids, id)
		}
	}

	return
}

func validate(results []bool) bool {
	for _, r := range results {
		if !r {
			return r
		}
	}
	return true
}
