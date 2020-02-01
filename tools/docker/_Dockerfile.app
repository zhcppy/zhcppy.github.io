FROM golang:1.12-alpine AS builder

ADD . /go/src/project-name

WORKDIR /go/src/project-name
RUN go build -o /go/bin/project-name

FROM alpine:latest
MAINTAINER zhanghang
LABEL maintainer="Zhang Hang <zhcppy@icloud.com>"

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

WORKDIR root

ARG HX_ENV
ENV HX_ENV ${HX_ENV:-dev}

COPY --from=builder /go/bin/project-name /usr/local/bin/project-name
RUN chmod +x /usr/local/bin/project-name

EXPOSE 5005

VOLUME ["/root"]

ENTRYPOINT ["project-name"]
