.DEFAULT_GOAL := help

test: ## Tests
	@(export proposalLoanMin=30000.0;\
		export proposalLoanMax=3000000.0;\
		export proposalDurationMin=2;\
		export proposalDurationMax=15;\
		export warrantyMin=1;\
		export warrantyValueMin=2.0;\
		export warrantyRefuseProvince=PR,SC,RS;\
		export proponentMin=2;\
		export proponentMain=1;\
		export proponentMinAge=18;\
		export proponentIncome1824=4.0;\
		export proponentIncome2450=3.0;\
		export proponentIncome50=2.0;\
		go test ./cmd -v -cover;)
run: ## Run file base
	@(export proposalLoanMin=30000.0;\
		export proposalLoanMax=3000000.0;\
		export proposalDurationMin=2;\
		export proposalDurationMax=15;\
		export warrantyMin=1;\
		export warrantyValueMin=2.0;\
		export warrantyRefuseProvince=PR,SC,RS;\
		export proponentMin=2;\
		export proponentMain=1;\
		export proponentMinAge=18;\
		export proponentIncome1824=4.0;\
		export proponentIncome2450=3.0;\
		export proponentIncome50=2.0;\
    go run main.go ${path};)
help: ## Display this help screen
	$(info Makefile Usage:)
	@grep -h -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
