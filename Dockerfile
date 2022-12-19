FROM alpine:edge
ENV password=123456 \
    wz=false \
    domain=www.baidu.com \
    email=10086@baidu.com
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash go openrc caddy caddy-openrc \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && go install -v -tags with_ech,with_utls,with_acme github.com/sagernet/sing-box/cmd/sing-box@dev-next \
        && cp $(go env GOPATH)/bin/sing-box /usr/bin/ \
	&& chmod +x /usr/bin/sing-box \
	&& chmod +x /entrypoint.sh \
        && mkdir /singbox \
	&& apk del go \
        && rm -rf /var/cache/apk/*
VOLUME /singbox
EXPOSE 443
ENTRYPOINT /entrypoint.sh
