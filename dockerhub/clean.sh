#!/usr/bin/env bash
[[ -n $DEBUG ]] && set -x
set -eou pipefail

usage() {
    cat <<HELP
USAGE:
    registry-clean pattern

    registry-clean head
HELP
}

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

pattern=$1

local_host="127.0.0.1:5100"

mirror_container_name="dockerhub_mirror_1"
local_container_name="dockerhub_local_1"
local_store_path="/cache/dockerhub"

docker stop "${mirror_container_name}"

set +e
regctl registry set --tls disabled "${local_host}"
fd "${pattern}" "${local_store_path}" | awk -F "/" '{print "regctl tag delete '"${local_host}"'/"$9"/"$10":"$13}' | bash
docker exec "${local_container_name}" /bin/registry garbage-collect /etc/docker/registry/config.yml -m
set -e

docker start "${mirror_container_name}"
