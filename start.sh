#!/bin/sh
set +x 

# 函数：检查网络连接
check_network() {
  local url=$1
  if curl -s --head --request GET --max-time 3 $url ; then
    echo "Internet is available for $url"
    return 0
  else
    echo "Internet is not available for $url"
    return 1
  fi
}

# 函数：启动 Registry 实例
start_registry() {
  local config_path=$1
  local proxy_url=$2

  if check_network $proxy_url; then
    echo "Starting registry with proxy mode using $config_path"
    exec registry serve $config_path &
  else
    echo "Starting registry in offline mode using $config_path"
    sed '/proxy:/,/remoteurl:/d' $config_path > /tmp/$(basename $config_path)_offline.yml
    exec registry serve /tmp/$(basename $config_path)_offline.yml &
  fi
}

# 启动 Caddy
start_caddy() {
  echo "Starting Caddy"
  exec caddy run --config /Caddyfile --adapter caddyfile &
}

# 更新 CA 证书
update-ca-certificates

# 确保日志目录存在
mkdir -p /var/log

# 启动不同的 Registry 实例
start_registry "/certs/ghcr.io/config.yml" "https://ghcr.io"
start_registry "/certs/k8s.gcr.io/config.yml" "https://k8s.gcr.io"
start_registry "/certs/quay.io/config.yml" "https://quay.io"
start_registry "/certs/registry-1.docker.io/config.yml" "https://registry-1.docker.io"
start_registry "/certs/registry.k8s.io/config.yml" "https://registry.k8s.io"

# 启动 Caddy
start_caddy

# 等待所有后台进程
wait
