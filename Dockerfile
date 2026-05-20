FROM golang:1.22 AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
go build -a -installsuffix cgo -ldflags="-s -w" -o /app/my_app

FROM scratch

COPY --from=builder /app/my_app /app/tracker.db /

CMD ["/my_app"]