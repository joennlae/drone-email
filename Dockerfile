FROM golang:1.8-alpine as builder

WORKDIR /go/src/drone-email
COPY . .

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build

FROM alpine:3.4

RUN apk add --no-cache ca-certificates

RUN export DRONE_PREV_BUILD_NUMBER=$(($DRONE_BUILD_NUMBER + 10000))

COPY --from=builder /go/src/drone-email/drone-email /bin/
ENTRYPOINT ["/bin/drone-email"]
