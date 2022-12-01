#!/bin/bash
ip=`curl ipv4.ip.sb --silent`
echo "当前主机ip是$ip"
echo "开始生成singbox配置文件"

if [[ $wz == ture ]]; then
    echo "你开启了域名配置使用自己的域名"
	yuming=$domain
elif [[ $wz == false ]]; then
	yuming=$ip.nip.io
	echo "没有配置域名使用nip.io域名$yuming"
fi
cat << EOF > /singbox/config.json
{
  "log": {
    "level": "error",
    "output": "/singbox/error.log",
    "timestamp": true
  },
  "inbounds": [
    {
      "type": "trojan",
      "tag": "trojan-in",
      "listen": "0.0.0.0",
      "listen_port": 443,
      "proxy_protocol": true,
      "proxy_protocol_accept_no_header": true,
      "tcp_fast_open": true,
      "udp_fragment": true,
      "users": [
        {
          "name": "mytrojan",
          "password": "$password"
        }
      ],
      "tls": {
        "enabled": true,
        "server_name": "$yuming",
        "alpn": [
          "h2",
          "http/1.1"
        ],
        "min_version": "1.2",
        "max_version": "1.3",
        "cipher_suites": [
        "TLS_CHACHA20_POLY1305_SHA256",
        "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256",
        "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256"
        ],
        "acme": {
          "domain": ["$yuming"],
          "data_directory": "/singbox",
          "email": "$email",
          "provider": "letsencrypt"
        }
      },
      "fallback": {
        "server": "127.0.0.1",
        "server_port": 8080
      }
    }
  ]
}
EOF

echo "开始生成Caddyfile配置文件"
cat <<EOF> /etc/caddy/Caddyfile
{
    servers 127.0.0.1:8080 {
      protocols h2c h1 
    }
}

:8080 {
    bind 127.0.0.1
    encode gzip
    log {
        level ERROR
    }
    respond "Service Unavailable" 503 {
        close
    }
}
EOF
openrc boot
/etc/init.d/caddy start
echo "当前设置的trojan密码为$password"
echo "当前设置的trojan域名为$yuming"
echo "当前设置申请ssl邮箱为$email"
sing-box run -c /singbox/config.json
tail -f /dev/null
