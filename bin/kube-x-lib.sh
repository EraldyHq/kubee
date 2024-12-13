# @name kube-x-lib
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
#     Return the directory of an app
# @arg $1 string The app namespace
kube::get_app_directory(){
  local APP_NAMESPACE="$1"
  # Check if we are under a KUBE_X_APP_HOME app home dir
  local KUBE_X_APP_HOMES=()
  IFS=":" read -ra KUBE_X_APP_HOMES <<< "${KUBE_X_APP_HOME_PATH:-}"
  # this works for executed script or sourced script
  local SCRIPT_DIR
  SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  local KUBE_X_RESOURCE_APP_DIR
  KUBE_X_RESOURCE_APP_DIR=$(realpath "$SCRIPT_DIR/../resources/apps")
  local KUBE_X_APP_HOMES+=("$KUBE_X_RESOURCE_APP_DIR")
  for KUBE_X_APP_HOME in "${KUBE_X_APP_HOMES[@]}"; do
      if [ ! -d "$KUBE_X_APP_HOME" ]; then
        echo::warn "The HOME path ($KUBE_X_HOME) set in KUBE_X_APP_HOME_PATH does not exist or is not a directory"
        continue
      fi
      local APP_DIR="$KUBE_X_APP_HOME/${APP_NAMESPACE}"
      if [ -d "$APP_DIR" ]; then
        echo "$APP_DIR"
        return
      fi
  done
  echo::err "No app namespace directory found with the name ($APP_NAMESPACE) in"
  echo::err "  * the cluster app resources directory (${KUBE_X_RESOURCE_APP_DIR}) "
  echo::err "  * or the paths of the KUBE_X_APP_HOME_PATH variable (${KUBE_X_APP_HOME_PATH:-'not set'})"
  return 1

}

# @description
#     Return the crds directory of an app
# @arg $1 string The app namespace
# @stdout the crds directory
# @exitcode 1 if there is no crds directory
# @exitcode 0 if there is a crds directory
kube::get_app_crds_directory(){

  local APP_NAMESPACE="$1"
  # this works for executed script or sourced script
  local SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  local KUBE_X_RESOURCE_APP_DIR=$(realpath "$SCRIPT_DIR/../resources/cluster/crds")
  local APP_CRDS_DIR="$KUBE_X_RESOURCE_APP_DIR/${APP_NAMESPACE}"
  if [ ! -d "$APP_CRDS_DIR" ]; then
    return 1
  fi
  echo "$APP_CRDS_DIR"

}

# @description
#     Return if the chart is already installed
# @args $1 - the release name
# @args $2 - the release namespace
# @args $3 - the chart app version that should be installed
# @exitcode 1 - if the chart is not installed or with another app version
kube::is_helm_chart_installed() {

  local CHART_RELEASE_NAME="$1"
  local CHART_RELEASE_NAMESPACE="$2"
  local CHART_APP_VERSION="$3"

  # Check if the release exists
  if ! helm status "$CHART_RELEASE_NAME" -n "$CHART_RELEASE_NAMESPACE" >/dev/null 2>&1; then
    echo::info "Release not found: $CHART_RELEASE_NAMESPACE/$CHART_RELEASE_NAME"
    return 1
  fi

  # Get the installed chart version
  read CHART_RELEASE_APP_VERSION CHART_RELEASE_CHART <<< "$(helm list -n "$CHART_RELEASE_NAMESPACE" --filter "^$CHART_RELEASE_NAME\$" --output json | jq -r '.[0] | "\(.app_version) \(.chart)"')"
  # We don't check on chart version
  IFS="-" read -ra CHART_RELEASE_PARTS <<< "$CHART_RELEASE_CHART"
  CHART_RELEASE_CHART_VERSION="${CHART_RELEASE_PARTS[-1]}"
  CHART_RELEASE_CHART_NAME=$({
   CHART_RELEASE_CHART_NAMES=(${CHART_RELEASE_PARTS[@]:0:${#CHART_RELEASE_PARTS[@]}-1});
   IFS='-';
   echo "${CHART_RELEASE_CHART_NAMES[*]}"
  })

  if [[ "$CHART_RELEASE_APP_VERSION" != "$CHART_APP_VERSION" ]]; then
    echo::info "Chart app version mismatch (Release App Version: $CHART_RELEASE_APP_VERSION. Chart App Version: $CHART_APP_VERSION)"
    return 1
  fi

  echo::info "Chart $CHART_RELEASE_CHART_NAME with version $CHART_RELEASE_CHART_VERSION and app version $CHART_APP_VERSION is already installed."


}


