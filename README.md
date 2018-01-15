# drone-github-tag

Drone plugin to tag commits to GitHub.

## Docker

Build the Docker image with the following commands:

```
docker build --rm=true -t quintoandar/drone-github-tag .
```

## Usage

Execute from the working directory:

```
docker run --rm \
  -e DRONE_REPO_OWNER=octocat \
  -e DRONE_REPO_NAME=foo \
  -e PLUGIN_API_KEY=./deploy_key.pem \
  -e PLUGIN_VERSION=0.0.1 \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  quintoandar/drone-github-tag
```

