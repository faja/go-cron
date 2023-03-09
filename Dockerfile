################################################################################
FROM golang:alpine3.17 AS build

WORKDIR /src
COPY go.mod go.sum /src/
RUN go mod download
COPY go-cron.go .

# -ldflags '-w' : removes debug stuff from the binary
#                 it makes the image much smaller
RUN CGO_ENABLED=0 go build -ldflags '-w' -o /bin/go-cron

################################################################################
FROM golang:alpine3.17

WORKDIR /
COPY --from=build /bin/go-cron /bin/go-cron
ENTRYPOINT ["/bin/sh"]
