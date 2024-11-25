# @name kube-x-config.sh documentation
# @brief Return a generated `KUBECONFIG` file from pass
# @description
# ## ENV
#
# * `KUBE_X_CLUSTER`: The cluster to connect (default to `default`)
# * `KUBE_X_USER`: The user to connect with (default to `default`)
# * `KUBE_X_PASS_HOME`: The directory where to store `kube-x` pass information (default to `kube-x`)
#
#
# ## How to create the secret in path
#
# ```bash
# # Set the config where to extract the information
# export KUBECONFIG="$HOME/.kube/config"
# # The pass home directory (default to kube-x)
# export KUBE_X_PASS_HOME="kube-x"
#
# # Get the cluster and user name from the KUBECONFIG
# # or set your own
# KUBE_X_CLUSTER=$(kubectl config view --minify --raw --output 'jsonpath={$.clusters[0].name}')
# KUBE_X_USER=$(kubectl config view --minify --raw --output 'jsonpath={$.users[0].name}')
#
# # Store the user and cluster properties in path
# kubectl config view --minify --raw --output 'jsonpath={$.users[0].client-certificate-data}' | pass insert -m "$KUBE_X_PASS_HOME/users/$KUBE_X_USER/client-certificate-data"
# kubectl config view --minify --raw --output 'jsonpath={$.users[0].client-key-data}' | pass insert -m "$KUBE_X_PASS_HOME/users/$KUBE_X_USER/client-key-data"
# kubectl config view --minify --raw --output 'jsonpath={$.clusters[0].certificate-authority-data}' | pass insert -m "$KUBE_X_PASS_HOME/clusters/$KUBE_X_CLUSTER/certificate-authority-data"
# kubectl config view --minify --raw --output 'jsonpath={$.clusters[0].server}' | pass insert -m "$KUBE_X_PASS_HOME/clusters/$KUBE_X_CLUSTER/server"
# ```


# Paths
PASS_CLIENT_TOKEN_PATH="$KUBE_X_PASS_HOME/users/$KUBE_X_USER/client-token"
PASS_CLIENT_CERT_PATH="$KUBE_X_PASS_HOME/users/$KUBE_X_USER/client-certificate-data"
PASS_CLIENT_KEY_DATA="$KUBE_X_PASS_HOME/users/$KUBE_X_USER/client-key-data"
PASS_CLUSTER_CERT_PATH="$KUBE_X_PASS_HOME/clusters/$KUBE_X_CLUSTER/certificate-authority-data"
PASS_CLUSTER_SERVER_PATH="$KUBE_X_PASS_HOME/clusters/$KUBE_X_CLUSTER/server"

###################
# Client
###################
# Token?
if ! KUBE_X_CLIENT_TOKEN=$(pass "$PASS_CLIENT_TOKEN_PATH" 2>/dev/null); then
  KUBE_X_CLIENT_TOKEN=""
  if ! KUBE_X_CLIENT_CERTIFICATE_DATA=$(pass "$PASS_CLIENT_CERT_PATH" 2>/dev/null); then
    echo::err "No client token or client certificate has been found in pass at $PASS_CLIENT_TOKEN_PATH and $PASS_CLIENT_CERT_PATH respectively"
    echo::err "Env:"
    echo::echo "$KUBECTX_ENV"
    exit 1
  fi
  # Private Key
  if ! KUBE_X_CLIENT_KEY_DATA=$(pass "$PASS_CLIENT_KEY_DATA" 2>/dev/null); then
    echo::err "No client key has been found in pass at $PASS_CLIENT_TOKEN_PATH and $PASS_CLIENT_CERT_PATH respectively"
    echo::err "Env:"
    echo::echo "$KUBECTX_ENV"
    exit 1
  fi
fi

###################
# Cluster
###################
if ! KUBE_X_CLUSTER_CERTIFICATE_AUTHORITY_DATA=$(pass "$PASS_CLUSTER_CERT_PATH" 2>/dev/null); then
  echo::err "No cluster certificate authority has been found in pass at $PASS_CLUSTER_CERT_PATH"
  echo::err "Env:"
  echo::echo "$KUBECTX_ENV"
  exit 1
fi

if ! KUBE_X_CLUSTER_SERVER=$(pass "$PASS_CLUSTER_SERVER_PATH" 2>/dev/null); then
  echo::err "No cluster server has been found in pass at $PASS_CLUSTER_PASS_CLUSTER_SERVER_PATH"
  echo::err "Env:"
  echo::echo "$KUBECTX_ENV"
  exit 1
fi


cat <<-EOF
apiVersion: v1
clusters:
  - name: $KUBE_X_CLUSTER
    cluster:
      certificate-authority-data: $KUBE_X_CLUSTER_CERTIFICATE_AUTHORITY_DATA
      server: $KUBE_X_CLUSTER_SERVER
contexts:
  - context:
      cluster: $KUBE_X_CLUSTER
      namespace: $KUBE_X_CONNECTION_NAMESPACE
      user: $KUBE_X_USER
    name: $KUBE_X_CONTEXT_NAME
current-context: $KUBE_X_CONTEXT_NAME
kind: Config
preferences: {}
users:
  - name: $KUBE_X_USER
    user:
      client-certificate-data: $KUBE_X_CLIENT_CERTIFICATE_DATA
      client-key-data: $KUBE_X_CLIENT_KEY_DATA
      token: $KUBE_X_CLIENT_TOKEN
EOF