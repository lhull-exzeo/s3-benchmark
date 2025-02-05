###############################################################################
### Environment Variables
###############################################################################
export GO15VENDOREXPERIMENT := 1

###############################################################################
### Dynamically list all targets.
### See: https://stackoverflow.com/a/26339924
###############################################################################
.PHONY: list
list:
	@$(MAKE) -pRrq -f $(MAKEFILE_LIST) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs -n 1

###############################################################################
### Build
###############################################################################
.PHONY: build
build: clean
	go build -o ${EXEC_NAME}

.PHONY: clean
clean:
	rm -f c.out
	rm -f $(EXEC_NAME)

###############################################################################
### Test
###############################################################################
test:
	go test -v -coverprofile=c.out ./...

cover: test
	go tool cover -html="c.out"

gotestsum:
	GOEXPERIMENT=nocoverageredesign gotestsum --format pkgname-and-test-fails --format-hide-empty-pkg -- -v -cover ./...

###############################################################################
### Initialize
###############################################################################
init:
	go mod download
	go mod tidy
	go mod vendor