# kubeode_registry
#

## 简介

`kubeode_registry` 是一个用于管理 Docker 镜像的私有容器注册中心。它基于 Docker Registry 构建，提供了稳定、高效的镜像存储与管理解决方案。

## 快速启动

使用以下命令启动 `kubeode_registry` 容器：

```bash
docker run -d \
  --name kubeode-registry \
  --network bridge \
  -p 443:443 \
  -p 6000:6000 \
  -v /usr/local/kubeode/package/offline/Images/data_registry:/var/lib/registry \
  --dns 8.8.8.8 \
  --dns 114.114.114.114 \
  --memory 512m \
  --memory-reservation 256m \
  --cpus 0.5 \
  --security-opt no-new-privileges \
  --restart unless-stopped \
  ghcr.io/szbjb/kubeode_registry:latest
```

### 参数说明

- `-d`：后台运行容器。
- `--name kubeode-registry`：指定容器名称为 `kubeode-registry`。
- `--network bridge`：将容器连接到默认的桥接网络。
- `-p 443:443`：将主机的443端口映射到容器的443端口，用于HTTPS访问。
- `-p 6000:6000`：将主机的6000端口映射到容器的6000端口，用于管理接口。
- `-v /usr/local/kubeode/package/offline/Images/data_registry:/var/lib/registry`：将主机目录挂载到容器内，用于持久化存储镜像数据。
- `--dns 8.8.8.8` 和 `--dns 114.114.114.114`：指定容器使用的DNS服务器。
- `--memory 512m`：限制容器使用的最大内存为512MB。
- `--memory-reservation 256m`：设置容器的内存保留为256MB。
- `--cpus 0.5`：限制容器使用的CPU为半个核心。
- `--security-opt no-new-privileges`：提升容器的安全性，防止添加新的权限。
- `--restart unless-stopped`：设置容器自动重启策略，除非手动停止。
- `ghcr.io/szbjb/kubeode_registry:latest`：指定使用的镜像及标签。

## 持久化存储

镜像数据存储在主机的 `/usr/local/kubeode/package/offline/Images/data_registry` 目录，确保数据在容器重启或删除后依然保留。

## DNS 配置

容器内使用的DNS服务器为 `8.8.8.8` 和 `114.114.114.114`，确保网络解析的稳定性和可靠性。

## 资源限制

为确保系统资源的合理分配，对容器的内存和CPU进行了限制，避免资源过度消耗影响系统其他服务。

## 安全配置

通过 `--security-opt no-new-privileges` 选项，提升容器的安全性，防止容器内的进程获取新的权限，降低潜在的安全风险。

## 自动重启

容器配置为 `unless-stopped` 重启策略，确保在系统重启或容器异常退出后自动恢复运行，提升服务的可用性。

## 版本信息

使用 `ghcr.io/szbjb/kubeode_registry:latest` 镜像，确保获取最新的功能和安全更新。

## 联系我们

如有任何问题或建议，请联系维护团队。