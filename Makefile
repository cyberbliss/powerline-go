# Go related commands
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test ./...
GOGET=$(GOCMD) get -u -v

# Name of actual binary to create
BINARY = powerline-go

# GOARCH tells go build which arch. to use while building a statically linked executable
GOARCH = amd64

# Setup the -ldflags option for go build here.
# While statically linking we want to inject version related information into the binary
#LDFLAGS = -ldflags="$$(govvv -flags)"

.PHONY: build
build:
	$(GOBUILD) -o release/$(BINARY)

# bin creates a platform specific statically linked binary. Platform sepcific because if you are on
# OS-X; linux binary will not work.
.PHONY: bin
bin:
	env CGO_ENABLED=0 GOOS=darwin GOARCH=${GOARCH} go build -a -installsuffix cgo -o ./release/${BINARY}-darwin-${GOARCH} . ;
	env CGO_ENABLED=0 GOOS=linux GOARCH=${GOARCH} go build -a -installsuffix cgo -o ./release/${BINARY}-linux-${GOARCH} . ;

# Runs unit tests.
.PHONY: test
test:
	$(GOTEST)

# Generates a coverage report
.PHONY: cover
cover:
	${GOCMD} test -coverprofile=coverage.out ./... && ${GOCMD} tool cover -html=coverage.out

# Remove coverage report and the binary.
.SILENT: clean
.PHONY: clean
clean:
	$(GOCLEAN)
	@rm -f ${BINARY}-darwin-${GOARCH}
	@rm -f ${BINARY}-linux-${GOARCH}
	@rm -f coverage.out

# There are much better ways to manage deps in golang, I'm going go get just for brevity
.PHONY: deps
deps:
	$(GOGET) github.com/mattn/go-runewidth
	$(GOGET) gopkg.in/ini.v1
	$(GOGET) github.com/shirou/gopsutil/load
	$(GOGET) github.com/shirou/gopsutil/mem
