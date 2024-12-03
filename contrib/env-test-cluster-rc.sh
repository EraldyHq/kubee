export KUBE_X_CLUSTER_NAME=kube-test
# Env file for the project
export PATH=$PWD/bin:$PATH
# Override any other default bashrc setting
export ANS_X_PROJECT_DIR=$PWD
# KUBE_X env
export KUBE_X_CLUSTER_API_SERVER_01_IP=78.46.190.50
export KUBE_X_CLUSTER_API_SERVER_01_NAME=kube-test-server-01
export KUBE_X_CLUSTER_APEX_DOMAIN=gerardnico.com
# Connection user
export KUBE_X_CLUSTER_SERVER_USER=root

export KUBE_X_CLUSTER_K3S_VERSION=v1.31.2+k3s1
# To generate a token: `openssl rand -base64 32 | tr -d '\n'`
export KUBE_X_CLUSTER_K3S_TOKEN=jbHWvQv9261KblczY7BX+OLcnZGrMSe+0UiFS3h7Ozc=
