package main

import (
	"go/cmd"
	"os"
)

func main() {

	args := os.Args
	path := args[1]

	//load rules
	rules := cmd.LoadRules("config/rules.json")

	cmd.Execute(path, rules)
}
