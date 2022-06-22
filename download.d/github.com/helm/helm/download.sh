#!/bin/sh

mkdir -p releases && cd releases
curl -fsSLO https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz
curl -fsSLO https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz.sha256sum
cd ..

mkdir -p scripts && cd scripts
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
cd ..
