# @name kubee-lib
# @brief A library of kubernetes functions
# @description
#     A library of kubernetes functions
#
#

# shellcheck source=./bashlib-echo.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-echo.sh"
# shellcheck source=./bashlib-command.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-command.sh"
# shellcheck source=./bashlib-bash.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-bash.sh"
# shellcheck source=./bashlib-path.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-path.sh"
# shellcheck source=./bashlib-template.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-template.sh"


# @description
#     Return the app name and namespace from a string
#     A qualified app name is made of one optional namespace and a name separated by a slash
#
# @arg $1 string The app name
# @example
#    read APP_NAMESPACE APP_NAME <<< "$(kube::get_qualified_app_name "$APP_NAME")"
#
# @stdout The app label ie `app.kubernetes.io/name=<app name>`
kube::get_qualified_app_name(){
  APP_NAME=$1
  IFS="/" read -ra NAMES <<< "$APP_NAME"
  case "${#NAMES[@]}" in
    '1')
      echo "${NAMES[0]} ${NAMES[0]}"
      ;;
    '2')
      echo "${NAMES[@]}"
      ;;
    *)
      echo::err "This app name ($APP_NAME) has more than 2 parts (ie ${#NAMES[@]})."
      echo::err "A qualified app name is made of one optional namespace and a name separated by a slash"
      echo::err "Example:"
      echo::err "  * traefik/traefik"
      echo::err "  * traefik"
      echo::err "  * prometheus/alertmanager"
      return 1
  esac
}

# @description
#     Return the app label used to locate resources
#     It will return the label `app.kubernetes.io/name=<app name>`
#     This is the common app label as seen on the [common label page](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/)
#
# @arg $1 string The app name
# @example
#    APP_LABEL="$(kube::get_app_label "$APP_NAME")"
#
# @stdout The app label ie `app.kubernetes.io/name=<app name>`
kube::get_app_label(){
  APP_NAME=$1
  echo "app.kubernetes.io/name=$APP_NAME"
}


# @description
#     Function to search for resources across all namespaces by app name
#     and returns data about them
#
# @arg $1 string `x`                  - the app name (mandatory) used in the label "app.kubernetes.io/name=$APP_NAME"
# @arg $2 string `--type x`           - the resource type: pod, ... (mandatory)
# @arg $3 string `--custom-columns x` - the custom columns (Default to `NAME:.metadata.name,NAMESPACE:.metadata.namespace`)
# @arg $4 string `--headers`          - the headers (Default to `no headers`)
# @example
#    PODS="$(kube::get_resources_by_app_name --type pod "$APP_NAME")"
#
#    PODS_WITH_NODE_NAME="$(kube::get_resources_by_app_name --type pod --custom-columns "NAME:.metadata.name,NAMESPACE:.metadata.namespace,NODE_NAME:.spec.nodeName" "$APP_NAME")"
#
# @stdout The resources data (one resource by line) or an empty string
kube::get_resources_by_app_name() {

  local APP_NAME=''
  local RESOURCE_TYPE=''
  local CUSTOM_COLUMNS='NAME:.metadata.name,NAMESPACE:.metadata.namespace'
  local NO_HEADERS="--no-headers"

  # Parsing the args
  while [[ $# -gt 0 ]]
  do
     case "$1" in
       "--type")
         shift
         RESOURCE_TYPE=$1
         shift
       ;;
      "--custom-columns")
         shift
         CUSTOM_COLUMNS=$1
         shift
      ;;
      "--headers")
        NO_HEADERS=""
        shift
      ;;
      *)
        if [ "$APP_NAME" == "" ]; then
          APP_NAME=$1
          shift
          continue
        fi
        if [ "$RESOURCE_TYPE" == "" ]; then
          RESOURCE_TYPE=$1
          shift
          continue
        fi
        echo::err "Too much arguments. The argument ($1) was unexpected"
        return 1
    esac
  done

  if [ "$APP_NAME" == "" ]; then
    echo::err "At least, the app name as argument should be given"
    return 1
  fi
  if [ "$RESOURCE_TYPE" == "" ]; then
    echo::err "The resource type is mandatory and was not found"
    return 1
  fi

  # App Label
  APP_LABEL=$(kube::get_app_label "$APP_NAME")

  #
  # Customs columns is a Json path wrapper.
  # Example:
  #     COMMAND="kubectl get $RESOURCE_TYPE --all-namespaces -l $APP_LABEL -o jsonpath='{range .items[*]}{.metadata.name}{\" \"}{.metadata.namespace}{\"\n\"}{end}' 2>/dev/null"
  #
  COMMAND="kubectl get $RESOURCE_TYPE --all-namespaces -l $APP_LABEL -o custom-columns='$CUSTOM_COLUMNS' $NO_HEADERS 2>/dev/null"
  echo::info "Executing: $COMMAND"
  eval "$COMMAND"

}

# @description
#     Function to search for 1 resource across all namespaces by app name
#     and returns data
#
# @arg $1 string `x`           - The app name
# @arg $2 string `--type type` - The resource type (pod, ...)
# @arg $3 string `--custom-columns x` - the custom columns (Default to `NAME:.metadata.name,NAMESPACE:.metadata.namespace`)
# @arg $4 string `--headers`          - the headers (Default to `no headers`)
# @example
#    read -r POD_NAME POD_NAMESPACE <<< "$(kube::get_resource_by_app_name --type pod "$APP_NAME" )"
#    if [ -z "$POD_NAME" ]; then
#        echo "Error: Pod not found with label $(kube::get_app_label $APP_NAME)"
#        exit 1
#    fi
#
# @stdout The resource name and namespace separated by a space or an empty string
# @exitcode 1 - if too many resource was found
kube::get_resource_by_app_name(){
  RESOURCES=$(kube::get_resources_by_app_name "$@")
  RESOURCE_COUNT=$(echo "$RESOURCES" | sed '/^\s*$/d' | wc -l )
  if [ "$RESOURCE_COUNT" -gt 1 ]; then
      echo "Error: Multiple resource found with the label app.kubernetes.io/name=$APP_NAME:"
      echo "$RESOURCES"
      exit 1
  fi;
  echo "$RESOURCES"
}


# @description
#     Return a json path to be used in a `-o jsonpath=x` kubectl option
# @arg $1 string The Json expressions (Default to: `.metadata.name .metadata.namespace`)
kube::get_json_path(){
  JSON_DATA_PATH_EXPRESSIONS=${1:-'.metadata.name .metadata.namespace'}
  JSON_PATH='{range .items[*]}'
  for DATA_EXPRESSION in $JSON_DATA_PATH_EXPRESSIONS; do
    # shellcheck disable=SC2089
    JSON_PATH="$JSON_PATH$DATA_EXPRESSION{\" \"}"
  done;
  JSON_PATH="$JSON_PATH{\"\n\"}{end}"
  echo "$JSON_PATH"
}




# @description
#     test the connection to the cluster
# @exitcode 1 - if the connection did not succeed
kube::test_connection(){

  if OUTPUT=$(kubectl cluster-info); then
    echo::info "Test Connection succeeded"
    return 0;
  fi
  echo::err "No connection could be made with the cluster"


  if [ "${KUBECONFIG:-}" == "" ]; then
        echo::err "Note: No KUBECONFIG env found"
  else
      if [ ! -f "$KUBECONFIG" ]; then
        echo::err "The KUBECONFIG env file ($KUBECONFIG) does not exist"
      else
        echo::info "The file ($KUBECONFIG) may have bad cluster info"
        echo::err "Note: The config is:"
        kubectl config view
      fi
  fi


  echo::err "We got the following output from the connection"
  echo::err "$OUTPUT"
  return 1

}

# @description
#     Return the directory of a cluster
# @arg $1 string The package name
kubee::get_cluster_directory(){

    local CLUSTER_NAME="$1"
    # All packages directories in an array
    local KUBEE_CLUSTER_DIRS=()
    IFS=":" read -ra KUBEE_CLUSTER_DIRS <<< "${KUBEE_CLUSTERS_PATH:-}"
    # this works for executed script or sourced script
    local SCRIPT_DIR
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    local KUBEE_RESOURCE_CLUSTERS_DIR
    KUBEE_RESOURCE_CLUSTERS_DIR=$(realpath "$SCRIPT_DIR/../resources/clusters")
    local KUBEE_CLUSTER_DIRS+=("$KUBEE_RESOURCE_CLUSTERS_DIR")
    for KUBEE_CLUSTER_DIR in "${KUBEE_CLUSTER_DIRS[@]}"; do
        if [ ! -d "$KUBEE_CLUSTER_DIR" ]; then
          echo::warn "The path ($KUBEE_CLUSTER_DIR) set in KUBEE_CLUSTERS_PATH does not exist or is not a directory"
          continue
        fi
        local CLUSTER_DIR="$KUBEE_CLUSTER_DIR/${CLUSTER_NAME}"
        if [ -d "$CLUSTER_DIR" ]; then
          echo "$CLUSTER_DIR"
          return
        fi
    done
    echo::err "No cluster directory found with the name ($CLUSTER_NAME) in"
    echo::err "  * the cluster built-in directory (${KUBEE_RESOURCE_CLUSTERS_DIR}) "
    echo::err "  * or the paths of the KUBEE_CLUSTERS_PATH variable (${KUBEE_CLUSTERS_PATH:-'not set'})"
    return 1


}

kubee::connection_print_env(){
  echo::err "Data Connection Values:"
  echo::err "KUBEE_USER_NAME             : $KUBEE_USER_NAME"
  echo::err "KUBEE_CLUSTER_NAME          : $KUBEE_CLUSTER_NAME"
  echo::err "KUBEE_CLUSTER_SERVER_01_IP  : ${KUBEE_CLUSTER_SERVER_01_IP:-}"
  echo::err ""
  echo::err "Did you set the cluster name or a KUBECONFIG env?"
}

kubee::connection_generate_config_from_pass(){


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
    kubee::connection_print_env
    return 1
  fi
  # Private Key
  if ! KUBEE_CLIENT_KEY_DATA=$(pass "$PASS_CLIENT_KEY_DATA" 2>/dev/null); then
    echo::err "No client key has been found in pass at $PASS_CLIENT_TOKEN_PATH and $PASS_CLIENT_CERT_PATH respectively"
    kubee::connection_print_env
    return 1
  fi
fi

###################
# Cluster
###################
if ! KUBEE_CLUSTER_CERTIFICATE_AUTHORITY_DATA=$(pass "$PASS_CLUSTER_CERT_PATH" 2>/dev/null); then
  echo::err "No cluster certificate authority has been found in pass at $PASS_CLUSTER_CERT_PATH"
  kubee::connection_print_env
  return 1
fi


if ! KUBEE_CLUSTER_SERVER=$(pass "$PASS_CLUSTER_SERVER_PATH" 2>/dev/null); then
  KUBEE_CLUSTER_SERVER_01_IP=${KUBEE_CLUSTER_SERVER_01_IP:-}
  if [ "$KUBEE_CLUSTER_SERVER_01_IP" == "" ]; then
    echo::err "No cluster server could found"
    echo::err "  No server data has been found in pass at $PASS_CLUSTER_PASS_CLUSTER_SERVER_PATH"
    echo::err "  No server ip was defined for the env KUBEE_CLUSTER_SERVER_01_IP"
    kubee::connection_print_env
    return 1
  fi
  KUBEE_CLUSTER_SERVER="https://$KUBEE_CLUSTER_SERVER_01_IP:6443"
  echo::debug "KUBEE_CLUSTER_SERVER ($KUBEE_CLUSTER_SERVER) built from KUBEE_CLUSTER_SERVER_01_IP"
else
  echo::debug "KUBEE_CLUSTER_SERVER ($KUBEE_CLUSTER_SERVER) built from pass $PASS_CLUSTER_SERVER_PATH"
fi


cat <<-EOF
apiVersion: v1
clusters:
  - name: $KUBEE_CLUSTER_NAME
    cluster:
      certificate-authority-data: $KUBEE_CLUSTER_CERTIFICATE_AUTHORITY_DATA
      server: $KUBEE_CLUSTER_SERVER
contexts:
  - context:
      cluster: $KUBEE_CLUSTER_NAME
      namespace: $KUBEE_CONNECTION_NAMESPACE
      user: $KUBEE_USER_NAME
    name: $KUBEE_CONTEXT_NAME
current-context: $KUBEE_CONTEXT_NAME
kind: Config
preferences: {}
users:
  - name: $KUBEE_USER_NAME
    user:
      client-certificate-data: $KUBEE_CLIENT_CERTIFICATE_DATA
      client-key-data: $KUBEE_CLIENT_KEY_DATA
      token: $KUBEE_CLIENT_TOKEN
EOF

}