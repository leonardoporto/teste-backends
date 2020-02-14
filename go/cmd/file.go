package cmd

import (
	"bytes"
	"fmt"
	"os"
)

func parser(path string) (lines []string) {
	file, err := os.Open(path)
	defer file.Close()
	if err != nil {
		fmt.Println(err.Error())
		return
	}
	stats, _ := file.Stat()

	data := make([]byte, stats.Size())
	count, err := file.Read(data)

	if err != nil {
		fmt.Println(err.Error())
		return
	}

	linesInBytes := bytes.Split(data[:count], []byte{'\n'})

	for _, line := range linesInBytes {
		lines = append(lines, string(line))
	}

	return
}

func convert2Proposal(lines []string) (proposals map[string]Proposal) {
	proposals = make(map[string]Proposal)

	// for _, line := range lines {
	// 	data := strings.Split(line, ",")
	// }

	return
}
