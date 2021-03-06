FROM golang:1.14.2-buster AS build

ADD . /src

RUN cd /src && \
    go build -o application ./cmd/application/

FROM alpine:3.11.5

# Fix that glibc binaries can run
RUN mkdir -p /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

WORKDIR /app

COPY --from=build /src/application /app/

EXPOSE 8080/tcp

ENTRYPOINT ./application
