FROM --platform=linux/amd64 golang:1.14-alpine3.12 AS build
RUN apk add --no-cache git
WORKDIR /s
COPY go.mod go.sum ./
RUN go mod download
COPY . ./
ARG VERSION
ARG OPTS
RUN export CGO_ENABLED=0 \
    && go build -ldflags "-X main.Version=test" -o /rtsp-simple-server

FROM --platform=linux/amd64 golang:1.14-alpine3.12
RUN apk add --no-cache \
    ffmpeg
COPY --from=build /rtsp-simple-server /rtsp-simple-server
RUN apk add bash
ENTRYPOINT [ "/rtsp-simple-server" ]

