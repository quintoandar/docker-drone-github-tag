#!/bin/sh
set -e

[ -z "$PLUGIN_VERSION" ] && echo "Missing version!" && exit 1
[ -z "$DRONE_REPO_NAME" ] && echo "Missing Drone repo name!" && exit 1
[ -z "$DRONE_REPO_OWNER" ] && echo "Missing Drone repo owner!" && exit 1

git tag ${PLUGIN_VERSION}

if [ -n "$GITHUB_TOKEN" ]; then
    git push https://${GITHUB_TOKEN}@github.com/${DRONE_REPO_OWNER}/${DRONE_REPO_NAME} ${PLUGIN_VERSION}
elif [ -f "$PLUGIN_API_KEY" ]; then
    mkdir -p /root/.ssh
    chmod 600 $PLUGIN_API_KEY
    touch /root/.ssh/known_hosts
    chmod 600 /root/.ssh/known_hosts
    eval "$(ssh-agent -s)"
    ssh-add $PLUGIN_API_KEY
    ssh-keyscan -H github.com > /etc/ssh/ssh_known_hosts 2> /dev/null
    git push git@github.com:${DRONE_REPO_OWNER}/${DRONE_REPO_NAME} ${PLUGIN_VERSION}
else
    echo "Missing GitHub Token or API Key file!" && exit 1
fi
