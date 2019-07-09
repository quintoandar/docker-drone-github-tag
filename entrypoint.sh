#!/bin/sh
set -e

[ -z "$PLUGIN_VERSION" ] && echo "Missing version!" && exit 1
[ -z "$DRONE_REPO_NAME" ] && echo "Missing Drone repo name!" && exit 1
[ -z "$DRONE_REPO_OWNER" ] && echo "Missing Drone repo owner!" && exit 1
[ -n "$DEPLOY_KEY" ] && PLUGIN_API_KEY=${DEPLOY_KEY};

EXTRA_ARGS="";
[ "${PLUGIN_FORCE}" == "true" ] && EXTRA_ARGS="-f";

git tag ${EXTRA_ARGS} ${PLUGIN_VERSION}

if [ -n "$GITHUB_TOKEN" ]; then
    git push ${EXTRA_ARGS} https://${GITHUB_TOKEN}@github.com/${DRONE_REPO_OWNER}/${DRONE_REPO_NAME} ${PLUGIN_VERSION}

elif [ -n "$PLUGIN_GITHUB_TOKEN" ]; then
    git push https://${PLUGIN_GITHUB_TOKEN}@github.com/${DRONE_REPO_OWNER}/${DRONE_REPO_NAME} ${PLUGIN_VERSION}

elif [ -n "$DRONE_NETRC_USERNAME" ]; then
    git push https://${DRONE_NETRC_USERNAME}@github.com/${DRONE_REPO_OWNER}/${DRONE_REPO_NAME} ${PLUGIN_VERSION}

elif [ -n "$PLUGIN_API_KEY" ]; then
    mkdir -p /root/.ssh
    touch /root/.ssh/known_hosts
    chmod 600 /root/.ssh/known_hosts
    ssh-keyscan -H github.com > /etc/ssh/ssh_known_hosts 2> /dev/null
    eval "$(ssh-agent -s)"

    # in case it is a file path
    if [ -f "$PLUGIN_API_KEY" ]; then
         cp $PLUGIN_API_KEY /root/.ssh/id_rsa
    else
         echo "$PLUGIN_API_KEY" > /root/.ssh/id_rsa
    fi

    chmod 600 /root/.ssh/id_rsa
    ssh-add /root/.ssh/id_rsa
    git push ${EXTRA_ARGS} git@github.com:${DRONE_REPO_OWNER}/${DRONE_REPO_NAME} ${PLUGIN_VERSION}

else
    echo "Missing GitHub Token ('$GITHUB_TOKEN', '$PLUGIN_GITHUB_TOKEN' or '$DRONE_NETRC_USERNAME') or API Key file ('$PLUGIN_API_KEY' or '$DEPLOY_KEY')!" && exit 1

fi
