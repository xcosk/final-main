FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o parcel-tracker .

FROM alpine:latest

RUN apk --no-cache add sqlite ca-certificates

WORKDIR /app

COPY --from=builder /app/parcel-tracker .

RUN mkdir -p /data

CMD ["./parcel-tracker"]