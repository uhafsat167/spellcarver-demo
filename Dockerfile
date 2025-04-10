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

# SECURITY DEMO - DO NOT DO THIS IN REAL LIFE!
# Setting hardcoded credentials (intentionally bad practice for demo)
ENV API_KEY="hunter2_obviously_a_bad_password"
ENV API_SECRET="admin123_so_secure_much_wow"
ENV DB_PASSWORD="correct_horse_battery_staple"

# Create credentials file with hardcoded values (extremely bad practice!)
RUN echo '{ \
  "api_key": "1234567890abcdef", \
  "api_secret": "password123!_dont_use_this", \
  "db_password": "letmein_security_nightmare" \
}' > /app/credentials.json

# Set credentials file path
ENV CREDENTIALS_FILE="/app/credentials.json"

# Run the application
CMD ["./helloworld"]
