package cmd

import (
	"bytes"
	"fmt"
	"os"
	"strings"
	"time"
)

type Event struct {
	ID string
}

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
	events := map[string]Event{}
	for _, line := range lines {
		data := strings.Split(line, ",")
		// Em caso de eventos repetidos, considere o primeiro evento
		_, exists := events[data[0]]
		if exists {
			continue
		}
		events[data[0]] = Event{data[0]}
		action := strings.Join(data[1:3], ".")
		// Em caso de eventos atrasados, considere sempre o evento mais novo
		date, _ := time.Parse("2006-01-02T15:04:05.000Z", data[3])
		ID := data[4]
		// verificamos se a proposta ja existe.
		// ignoramos este fato somente quando a ação for de criar
		proposal, exists := proposals[ID]
		if !exists && action != "proposal.created" {
			fmt.Printf("Proposal not exists - action %q", action)
			continue
		}

		// realizamos a ação
		switch action {
		case "proposal.created":
			proposals[ID] = create(ID, data[5:], date)
		case "proposal.updated":
			proposal.update(data[5:], date)
		case "proposal.removed":
			proposal.delete(date)
		case "warranty.added":
			w := createWarranty(data[:5], date)
			proposal.warrantyAdd(w)
		case "warranty.updated":
			result := proposal.warrantyUpdate(data[5:], date)
			if !result {
				fmt.Printf("Warranty not exists - action %q", action)
			}
		case "warranty.removed":
			result := proposal.warrantyRemove(data[5], date)
			if !result {
				fmt.Printf("Warranty not exists - action %q", action)
			}
		case "proponent.added":
			p := createProponent(data[5:], date)
			proposal.proponentAdd(p)
		case "proponent.updated":
			result := proposal.proponentUpdate(data[5:], date)
			if !result {
				fmt.Printf("Proponent not exists - action %q", action)
			}
		case "proponent.removed":
			result := proposal.proponentRemove(data[5], date)
			if !result {
				fmt.Printf("Proponent not exists - action %q", action)
			}
		}

	}

	return
}
