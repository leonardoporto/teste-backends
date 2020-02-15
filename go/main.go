package main

import (
	"go/cmd"
	"os"
)

func main() {

	args := os.Args

	path := args[1]

	cmd.Execute(path)
}
