FROM ubuntu:18.04

# Install necessary packages
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
        build-essential

RUN apt-get update -y
RUN apt-get install -y libx11-dev

# Download and install Go
ENV GO_VERSION 1.20.6
RUN curl -LO "https://go.dev/dl/go1.20.6.linux-amd64.tar.gz" && \
    tar -C /usr/local -xzf "go1.20.6.linux-amd64.tar.gz" && \
    rm "go1.20.6.linux-amd64.tar.gz"

# Set Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"
ENV GOBIN="/go/bin"

# Create a directory for Go workspace
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Set CGO_ENABLED to enable cgo
RUN go env -w CGO_ENABLED=1

# Set the working directory
WORKDIR $GOPATH/src

COPY . .

RUN ls

RUN go build .

# Print Go version to verify the installation
RUN go version

# Your additional configurations and code can be added here.

# By default, run bash for interactive access (optional)
CMD ["/bin/bash"]