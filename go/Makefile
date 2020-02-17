.DEFAULT_GOAL := help

rules: ## Load rules
	$(export proposalLoanMin=30000.0;\
	export proposalLoanMax=3000000.0;)
test: ## Tests
	go test ./cmd -v -cover 
run: ## Run file base
	go run main.go input999.txt
help: ## Display this help screen
	$(info Makefile Usage:)
	@grep -h -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
