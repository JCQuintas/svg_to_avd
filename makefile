PROJECTNAME = "svg_to_avd"
ROOT := $(shell git rev-parse --show-toplevel)
FLUTTER := $(shell which flutter)
FLUTTER_BIN_DIR := $(shell dirname $(FLUTTER))
FLUTTER_DIR := $(FLUTTER_BIN_DIR:/bin=)
DART := $(FLUTTER_BIN_DIR)/cache/dart-sdk/bin/dart

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
	$(DART) run test --coverage=./coverage
	$(DART) pub global activate coverage
	$(DART) pub global run coverage:format_coverage --check-ignore --packages=.packages --report-on=lib --lcov -o ./coverage/lcov.info -i ./coverage
	lcov --remove coverage/lcov.info '*.g.dart' -o coverage/lcov.info
	genhtml -o ./coverage/report ./coverage/lcov.info
	open ./coverage/report/index.html