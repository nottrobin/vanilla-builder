#!/usr/bin/env bash

set -ex

source lib/functions.sh

 # Check this version doesn't exist
if [[ -z "${4}" ]]; then
    echo 'Not all options specified.'
    echo 'Usage: publish.sh ${FRAMEWORK_REPOSITORY} ${RELEASE_LEVEL} ${RELEASE_DESCRIPTION} ${ASSETS_SERVER_URL} ${ASSETS_SERVER_TOKEN}'
    exit 1
fi

# Settings
export framework_repository=$1
export release_level=$2
export release_description=$3
export assets_server_url=$4
export assets_server_token=$5
export FRAMEWORK_DIR=`pwd`/framework
export HOMEPAGE_DIR=`pwd`/homepage
export LIB_DIR=`pwd`/lib

prepare_directories ${framework_repository}

update_info="$(increment_npm_version ${release_level})"
old_version=$(echo "${update_info}" | grep 'Old version' | sed 's/Old version[:] \(\.*\)/\1/g')
new_version=$(echo "${update_info}" | grep 'New version' | sed 's/New version[:] \(\.*\)/\1/g')

#npm_publish

add_version_tag ${new_version}
compile_css
upload_css ${new_version} ${assets_server_url} ${assets_server_token}
update_docs ${new_version}
update_project_homepage ${old_version} ${new_version} "${release_description}"
