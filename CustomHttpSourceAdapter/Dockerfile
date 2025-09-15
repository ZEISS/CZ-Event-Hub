FROM golang:1.24 AS builder

WORKDIR /app

RUN apt install ca-certificates
COPY trusted_certs.pem /etc/ssl/certs/trusted_certs.pem

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY main.go .

RUN CGO_ENABLED=0 go build -o /main

# FROM gcr.io/distroless/static
# COPY --from=builder /app /app

# WORKDIR /app
EXPOSE 8080

CMD ["/main"]
