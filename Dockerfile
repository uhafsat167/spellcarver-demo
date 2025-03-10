# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Create empty go.mod file if it doesn't exist
RUN touch go.mod.tmp

# Copy go.mod (will overwrite the empty one if it exists)
COPY go.mod go.mod.tmp
RUN if [ -s go.mod.tmp ]; then mv go.mod.tmp go.mod; else echo "module helloworld\n\ngo 1.21" > go.mod; fi

# Initialize the module and dependencies
RUN go mod tidy

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/helloworld .

# Final stage
FROM alpine:3.18

WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/helloworld .

# Run the application
CMD ["./helloworld"]
