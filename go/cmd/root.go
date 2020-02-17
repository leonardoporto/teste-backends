package cmd

import (
	"fmt"
	"strings"
)

//Execute Responsible for executing the processes
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
	r := LoadRules()
	for id, p := range proposals {
		results := []bool{}
		results = append(results, r.Proposal.validate(p))
		results = append(results, r.Warranty.validate(p))
		results = append(results, r.Proponent.validate(p))
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
