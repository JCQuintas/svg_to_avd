PROJECTNAME = "svg_to_avd"
ROOT := $(shell git rev-parse --show-toplevel)
DART := $(shell which dart)
COVERDE := $(shell which coverde)
REPLACE := $(shell which replace)
IGNORE_OUTPUT := >/dev/null
FILTER_OPTIONS := \.g.dart,\.freezed.dart

.PHONY: help
## help: this help prompt
help: Makefile
	@echo
	@echo "Choose a command to run in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'


.PHONY: test
## test: test the app
test:
	$(DART) run test --chain-stack-traces

.PHONY: coverage
## coverage: collect test coverage for the app
coverage:
	@if ! which coverde $(IGNORE_OUTPUT); then $(DART) pub global activate coverde; fi
	@if ! which replace $(IGNORE_OUTPUT); then $(DART) pub global activate replace; fi
	@if ! which coverage $(IGNORE_OUTPUT); then $(DART) pub global activate coverage; fi
	$(DART) run test --coverage=./coverage
	$(DART) pub global run coverage:format_coverage --check-ignore --report-on=lib --lcov -o ./coverage/lcov.info -i ./coverage
	@$(COVERDE) filter -f $(FILTER_OPTIONS) -m w $(IGNORE_OUTPUT)
	@$(REPLACE) $(shell pwd) '' coverage/filtered.lcov.info $(IGNORE_OUTPUT)
	$(COVERDE) report -l -i coverage/filtered.lcov.info $(IGNORE_OUTPUT)

