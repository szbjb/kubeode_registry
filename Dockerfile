# 使用官方的 registry:2 作为基础镜像
FROM registry:2

# 切换到 root 用户以便安装软件包
USER root

# 安装 curl 并清理缓存
RUN apk update && \
    apk add --no-cache curl  caddy && \
    rm -rf /var/cache/apk/*

COPY  registry_certs   /certs
COPY  start.sh   /
COPY  Caddyfile   /

CMD  ["/start.sh"]
