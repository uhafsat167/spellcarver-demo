# FROM alpine
# CMD ["echo", "Hello, World!"]
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y curl openssl=1.1.1f-1ubuntu2
