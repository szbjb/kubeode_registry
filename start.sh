#!/bin/sh
set +x 

# 函数：检查网络连接
check_network() {
  local test_url="https://www.google.com"
  if curl -s --head --request GET --max-time 3 $test_url ; then
    echo "Internet is available for $test_url"
    return 0
  else
    echo "Internet is not available for $test_url"
    return 1
  fi
}

# 函数：启动 Registry 实例
start_registry() {
  local config_path=$1
  local proxy_name=$(basename $(dirname $config_path))

  if check_network; then
    echo "Starting registry with proxy mode using $config_path"
    exec registry serve $config_path &
  else
    local offline_config_dir="/tmp/$proxy_name"
    mkdir -p $offline_config_dir
    local offline_config_path="$offline_config_dir/$(basename $config_path)_offline.yml"
    echo "Starting registry in offline mode using $offline_config_path"
    sed '/proxy:/,/remoteurl:/d' $config_path > $offline_config_path
    exec registry serve $offline_config_path &
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
start_registry "/certs/ghcr.io/config.yml"
start_registry "/certs/k8s.gcr.io/config.yml"
start_registry "/certs/quay.io/config.yml"
start_registry "/certs/registry-1.docker.io/config.yml"
start_registry "/certs/registry.k8s.io/config.yml"

# 启动 kubeode.registry.local 的 Registry 实例
echo "Starting registry for kubeode.registry.local"
exec registry serve /certs/kubeode.registry.local/config.yml &

# 启动 Caddy
start_caddy

# 等待所有后台进程
wait
