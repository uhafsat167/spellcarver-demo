# Go Hello World

A simple Go web server that responds with "Hello, World!".

## Building and Running with Docker

### Build the Docker image

```bash
docker build -t go-hello-world .
```

### Run the Docker container

```bash
docker run -p 8080:8080 go-hello-world
```

The application will be accessible at http://localhost:8080

## Running Locally

### Prerequisites

- Go 1.21 or later ##1.2.2

### Run the application

```bash
go run main.go
```

The application will be accessible at http://localhost:8080

## Environment Variables

- `PORT`: The port on which the server will listen (default: 8080)

## new line
