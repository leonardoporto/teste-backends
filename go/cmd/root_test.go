package cmd

import "testing"

func TestCheckProposals(t *testing.T) {

	tests := []struct {
		name string
		in   string
		out  int
	}{
		{"000", "../../test/input/input000.txt", 3},
		{"001", "../../test/input/input001.txt", 3},
		{"002", "../../test/input/input002.txt", 3},
		{"003", "../../test/input/input003.txt", 3},
		{"004", "../../test/input/input004.txt", 2},
		{"005", "../../test/input/input005.txt", 3},
		{"006", "../../test/input/input006.txt", 3},
		{"007", "../../test/input/input007.txt", 3},
		{"008", "../../test/input/input008.txt", 2},
		{"009", "../../test/input/input009.txt", 4},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// damos load no arquivo
			lines := parser(tt.in)
			// convertemos linhas em propostas
			proposals := convert2Proposal(lines)
			// inicia validacao
			result := check(proposals)

			if len(result) != tt.out {
				t.Errorf("failed %q", tt.name)
			}
		})
	}
}
