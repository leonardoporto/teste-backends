package cmd

import (
	"fmt"
	"strings"
)

var r Rules

func Execute(path string, rules Rules) {

	r = rules
	// damos load no arquivo
	lines := parser(path)
	// convertemos linhas em propostas
	proposals := convert2Proposal(lines)
	// inicia validacao
	result := check(proposals)
	fmt.Println(strings.Join(result, ","))
}

func check(proposals map[string]Proposal) (ids []string) {

	for id, p := range proposals {
		results := []bool{}
		results = append(results, r.Proposal.validate(p))
		results = append(results, r.Warranty.validate(p))
		results = append(results, r.Proponent.validate(p))
		fmt.Println(p.ID)
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
