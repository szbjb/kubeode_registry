# 使用官方的 registry:2 作为基础镜像
FROM registry:2

# 切换到 root 用户以便安装软件包
USER root

# 安装 curl 并清理缓存
RUN apk update && \
    apk add --no-cache curl caddy && \
    rm -rf /var/cache/apk/*

# 复制证书到容器中
COPY registry_certs /certs

# 添加所有证书到信任存储
RUN for cert in /certs/*/*/domain.crt; do \
        cp "$cert" "/usr/local/share/ca-certificates/$(basename $(dirname "$cert")).crt"; \
    done && \
    update-ca-certificates

# 复制其他文件
COPY start.sh /
COPY Caddyfile /

CMD ["/start.sh"]