package cmd

import "testing"

func TestParser(t *testing.T) {
	tests := []struct {
		name string
		in   string
		out  int
	}{
		{"Parser / invalid path", "/teste.txt", 0},
		{"Parser / valid path", "../../test/input/input000.txt", 20},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := parser(tt.in)
			if len(result) != tt.out {
				t.Errorf("failed %q, expected %d and result %d", tt.name, tt.out, len(result))
			}
		})
	}
}

func TestConvert(t *testing.T) {
	tests := []struct {
		name string
		in   []string
		out  int
	}{
		{"Convert", parser("../../test/input/input001.txt"), 4},
		{"Convert", parser("../../test/input/input004.txt"), 6},
		{"Convert", parser("../input999.txt"), 1},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := convert2Proposal(tt.in)
			if len(result) != tt.out {
				t.Errorf("failed %q, expected %d and result %d", tt.name, tt.out, len(result))
			}
		})
	}
}
