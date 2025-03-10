# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go.mod file
COPY go.mod ./

# Initialize go.mod and download dependencies
# This approach doesn't require go.sum to exist
RUN go mod download && go mod tidy

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
