FROM alpine:edge
ENV password=123456 \
    wz=false \
    domain=www.baidu.com \
    email=10086@baidu.com
ADD entrypoint.sh /entrypoint.sh
RUN set -ex \
        && apk update -f && apk upgrade \
        && apk --no-cache add -f ca-certificates tzdata wget curl bash openrc caddy caddy-openrc\
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && curl -L https://mirror.apad.pro/trojan/sing-box_1.1-beta15_linux_amd64.tar.gz -o sing-box_1.1-beta15_linux_amd64.tar.gz \
        && tar -C /usr/bin -xzf sing-box_1.1-beta15_linux_amd64.tar.gz \
	   && chmod +x /usr/bin/sing-box \
	   && chmod +x /entrypoint.sh \
        && mkdir /singbox \
        && rm -rf sing-box_1.1-beta15_linux_amd64.tar.gz \
        && rm -rf /var/cache/apk/*
VOLUME /singbox
EXPOSE 443
ENTRYPOINT /entrypoint.sh
