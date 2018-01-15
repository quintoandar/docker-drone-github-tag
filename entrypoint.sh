#!/bin/sh
set -e

[ -z "$PLUGIN_VERSION" ] && echo "Missing version!" && exit 1
[ -z "$DRONE_REPO_NAME" ] && echo "Missing Drone repo name!" && exit 1
[ -z "$DRONE_REPO_OWNER" ] && echo "Missing Drone repo owner!" && exit 1

git tag ${PLUGIN_VERSION}

if [ -n "$GITHUB_TOKEN" ]; then
    git push https://${GITHUB_TOKEN}@github.com/${DRONE_REPO_OWNER}/${DRONE_REPO_NAME} ${PLUGIN_VERSION}

elif [ -n "$PLUGIN_API_KEY" ]
    mkdir -p /root/.ssh
    touch /root/.ssh/known_hosts
    chmod 600 /root/.ssh/known_hosts
    ssh-keyscan -H github.com > /etc/ssh/ssh_known_hosts 2> /dev/null
    eval "$(ssh-agent -s)"

    # in case it is a file path
    if [ -f "$PLUGIN_API_KEY" ]; then
         cp $PLUGIN_API_KEY /root/.ssh/id_rsa
    else
         echo $PLUGIN_API_KEY > /root/.ssh/id_rsa
    fi

    chmod 600 /root/.ssh/id_rsa
    ssh-add /root/.ssh/id_rsa
    git push git@github.com:${DRONE_REPO_OWNER}/${DRONE_REPO_NAME} ${PLUGIN_VERSION}

else
    echo "Missing GitHub Token or API Key file!" && exit 1

fi
