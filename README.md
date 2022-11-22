# trojan

```
# 推荐部署容器命令
``` sh
docker run --restart=always \
  -d --name trojan \
  --privileged=true \
  -p 443:443 \
  -p 80:80 \
  -v /docker/singbox:/singbox \
  -e password=123456 \
  -e email=10086@baidu.com \
  -e wz=false \
  -e domain=1.baidu.com \
  byxiaopeng/trojan:latest
```


#password  trojan密码

#email     申请ssl证书邮箱

#wz        是否使用自己域名开关 ture开 false关  不开启默认使用nip.io域名

#domain    填写自己的域名

重启trojan容器代码
``` sh
docker restart trojan
```

