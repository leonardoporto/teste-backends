package cmd

import "testing"

func TestCheckProposals(t *testing.T) {

	tests := []struct {
		name string
		in   string
		out  int
	}{
		{"001", "../../test/input/input000.txt", 3},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// damos load no arquivo
			lines := parser(tt.in)
			// convertemos linhas em propostas
			proposals := convert2Proposal(lines)
			// inicia validacao
			result := check(proposals)

			if len(result) == tt.out {
				t.Errorf("Error")
			}
		})
	}
}
