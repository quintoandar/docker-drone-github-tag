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

On a Drone pipeline (tested with 0.8.5):

```
  tag:
    group: publish
    image: quintoandar/drone-github-tag
    version: ${DRONE_COMMIT:0:7}
    when:
      branch: ["master"]
      event: ["push"]
```

The api key/github token is optional on Drone, because it automatically reads the token from DRONE_NETRC_USERNAME environment variable by default.
