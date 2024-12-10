
domain="
kubeode.registry.local
ghcr.io
k8s.gcr.io
quay.io
registry-1.docker.io
registry.k8s.io
registry.kubeode.down.local
kubeode.down.local
docker.io
"

for domain in $domain; do

# 生成新的证书
mkdir  -pv registry_certs/$domain/

cat > registry_certs/$domain/openssl.cnf <<EOF
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
CN = $domain

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




openssl req -new -newkey rsa:4096 -nodes -sha256 -keyout registry_certs/$domain/domain.key -x509 -days 365 -out registry_certs/$domain/domain.crt -config registry_certs/$domain/openssl.cnf -extensions v3_req

done
