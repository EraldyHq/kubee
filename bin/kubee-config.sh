# @name kubee-config.sh documentation
# @brief Return a `KUBECONFIG` file
# @description
#
# If the `KUBECONFIG` env is not set, `kubee` will generate it dynamically.
#
# ## How
#
# It retrieves:
# * the `cluster` data from the `pass` secret manager.
# * the `user` data from the `pass` secret manager.
# * the `namespace` from the env
#
# It's a `zero-trust` connection tool.
#
# ## ENV
#
# * `KUBEE_CLUSTER_NAME`: The cluster to connect (default to `default`)
# * `KUBEE_CLUSTER_SERVER_01_IP`: the server ip used by default
# * `KUBEE_USER_NAME`: The user to connect with (default to `default`)
# * `KUBEE_PASS_HOME`: The directory where to store `kubee` pass information (default to `kubee`)
# * `KUBEE_CONNECTION_NAMESPACE`: the connection namespace (default to the app namespace or to the KUBEE_DEFAULT_NAMESPACE)
#
# ## How to create the secrets in path
#
# ```bash
# # Set the config where to extract the information
# export KUBECONFIG="$HOME/.kube/config"
# # The pass home directory (default to kubee)
# export KUBEE_PASS_HOME="kubee"
#
# # Get the cluster and user name from the KUBECONFIG
# # or set your own
# KUBEE_CLUSTER_NAME=$(kubectl config view --minify --raw --output 'jsonpath={$.clusters[0].name}')
# KUBEE_USER_NAME=$(kubectl config view --minify --raw --output 'jsonpath={$.users[0].name}')
#
# # Store the user and cluster properties in path
# kubectl config view --minify --raw --output 'jsonpath={$.users[0].client-certificate-data}' | pass insert -m "$KUBEE_PASS_HOME/users/$KUBEE_USER_NAME/client-certificate-data"
# kubectl config view --minify --raw --output 'jsonpath={$.users[0].client-key-data}' | pass insert -m "$KUBEE_PASS_HOME/users/$KUBEE_USER_NAME/client-key-data"
# kubectl config view --minify --raw --output 'jsonpath={$.clusters[0].certificate-authority-data}' | pass insert -m "$KUBEE_PASS_HOME/clusters/$KUBEE_CLUSTER_NAME/certificate-authority-data"
# # The server URI is derived from KUBEE_CLUSTER_SERVER_01_IP
# ```

print_env(){
  echo::err "Env:"
  echo::echo "KUBEE_USER_NAME: $KUBEE_USER_NAME"
  echo::echo "KUBEE_CLUSTER_NAME: $KUBEE_CLUSTER_NAME"
  echo::echo "KUBEE_CLUSTER_SERVER_01_IP: ${KUBEE_CLUSTER_SERVER_01_IP:-}"
}
# Paths
PASS_CLIENT_TOKEN_PATH="$KUBEE_PASS_HOME/users/$KUBEE_USER_NAME/client-token"
PASS_CLIENT_CERT_PATH="$KUBEE_PASS_HOME/users/$KUBEE_USER_NAME/client-certificate-data"
PASS_CLIENT_KEY_DATA="$KUBEE_PASS_HOME/users/$KUBEE_USER_NAME/client-key-data"
PASS_CLUSTER_CERT_PATH="$KUBEE_PASS_HOME/clusters/$KUBEE_CLUSTER_NAME/certificate-authority-data"
PASS_CLUSTER_SERVER_PATH="$KUBEE_PASS_HOME/clusters/$KUBEE_CLUSTER_NAME/server"


###################
# Client
###################
# Token?
if ! KUBEE_CLIENT_TOKEN=$(pass "$PASS_CLIENT_TOKEN_PATH" 2>/dev/null); then
  KUBEE_CLIENT_TOKEN=""
  if ! KUBEE_CLIENT_CERTIFICATE_DATA=$(pass "$PASS_CLIENT_CERT_PATH" 2>/dev/null); then
    echo::err "No client token or client certificate has been found in pass at $PASS_CLIENT_TOKEN_PATH and $PASS_CLIENT_CERT_PATH respectively"
    print_env
    exit 1
  fi
  # Private Key
  if ! KUBEE_CLIENT_KEY_DATA=$(pass "$PASS_CLIENT_KEY_DATA" 2>/dev/null); then
    echo::err "No client key has been found in pass at $PASS_CLIENT_TOKEN_PATH and $PASS_CLIENT_CERT_PATH respectively"
    print_env
    exit 1
  fi
fi

###################
# Cluster
###################
if ! KUBEE_CLUSTER_CERTIFICATE_AUTHORITY_DATA=$(pass "$PASS_CLUSTER_CERT_PATH" 2>/dev/null); then
  echo::err "No cluster certificate authority has been found in pass at $PASS_CLUSTER_CERT_PATH"
  print_env
  exit 1
fi


if ! KUBEE_CLUSTER_SERVER=$(pass "$PASS_CLUSTER_SERVER_PATH" 2>/dev/null); then
  KUBEE_CLUSTER_SERVER_01_IP=${KUBEE_CLUSTER_SERVER_01_IP:-}
  if [ "$KUBEE_CLUSTER_SERVER_01_IP" == "" ]; then
    echo::err "No cluster server could found"
    echo::err "  No server data has been found in pass at $PASS_CLUSTER_PASS_CLUSTER_SERVER_PATH"
    echo::err "  No server ip was defined for the env KUBEE_CLUSTER_SERVER_01_IP"
    print_env
    exit 1
  else
  KUBEE_CLUSTER_SERVER="https://$KUBEE_CLUSTER_SERVER_01_IP:6443"
fi


cat <<-EOF
apiVersion: v1
clusters:
  - name: $KUBEE_CLUSTER
    cluster:
      certificate-authority-data: $KUBEE_CLUSTER_CERTIFICATE_AUTHORITY_DATA
      server: $KUBEE_CLUSTER_SERVER
contexts:
  - context:
      cluster: $KUBEE_CLUSTER
      namespace: $KUBEE_CONNECTION_NAMESPACE
      user: $KUBEE_USER
    name: $KUBEE_CONTEXT_NAME
current-context: $KUBEE_CONTEXT_NAME
kind: Config
preferences: {}
users:
  - name: $KUBEE_USER
    user:
      client-certificate-data: $KUBEE_CLIENT_CERTIFICATE_DATA
      client-key-data: $KUBEE_CLIENT_KEY_DATA
      token: $KUBEE_CLIENT_TOKEN
EOF