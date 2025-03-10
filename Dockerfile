# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go.mod file
COPY go.mod ./

# Copy go.sum file if it exists (will not fail if missing)
COPY go.sum* ./

# Download dependencies
RUN go mod download

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
