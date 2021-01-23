FROM golang:latest-alpine AS build_base

RUN apk add --no-cache git

WORKDIR /tmp/simple-app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go test -v

RUN go build -o ./out/simple-app .

FROM alpine:latest
RUN apk add ca-certificates

COPY --from=build_base /tmp/simple-app/out/simple-app /app/simple-app

EXPOSE 5000

CMD ["/app/simple-app"]
