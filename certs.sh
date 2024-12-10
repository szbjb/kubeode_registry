 cat > certs/kubeode.registry.local/openssl.cnf <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C = XX
ST = State
L = City
O = Organization
OU = Department
CN = kubeode.registry.local

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = kubeode.registry.local
DNS.2 = ghcr.io
DNS.3 = k8s.gcr.io
DNS.4 = quay.io
DNS.5 = registry-1.docker.io
DNS.6 = registry.k8s.io
DNS.7 = registry.kubeode.down.local
DNS.8 = kubeode.down.local
DNS.9 = docker.io
EOF



# 生成新的证书
mkdir  -pv certs/kubeode.registry.local/
openssl req -new -newkey rsa:4096 -nodes -sha256 -keyout certs/kubeode.registry.local/domain.key -x509 -days 365 -out certs/kubeode.registry.local/domain.crt -config certs/kubeode.registry.local/openssl.cnf -extensions v3_req

# 将证书和密钥复制到registry_certs目录 
cp certs/kubeode.registry.local/domain.crt registry_certs/
cp certs/kubeode.registry.local/domain.key registry_certs/
