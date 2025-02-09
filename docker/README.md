# Docker instructions

Navigate to the 'docker' folder that contains the Dockerfile and run the following command to build the image with
heaa-ai repository latest commit:

## Building docker image:

```
docker build -t <imagename> .
```

example:

```
docker build -t heaa-ai .
```

`no_threads` is an argument (with a default value of 1 if it is not passed as an argument) for running make with
the `-j` flag while installing heaa-ai in the docker build. A different value for the number of threads can be passed as
an argument to the docker build with the following command:

```
docker build -t heaa-ai . --build-arg no_threads=4
```

`CC_param` and `CXX_param` are used to set the compiler for C++, the **default compiler** is `g++-10` if the arguments
are not set.

example:

```
docker build -t heaa-ai . --build-arg no_threads=1 --build-arg CC_param=/usr/bin/clang-10 --build-arg=/usr/bin/clang++-10
```

The heaa-ai repository and the release tag are also arguments that can be passed to the docker build to build the
corresponding image (the default repository is heaa-ai, main branch and the latest commit).

For example, to build heaa-ai-release v1.10.6, run the following command:

```
docker build -t heaa-ai-release . --build-arg repository=heaa-ai-release --build-arg tag=tags/v1.10.6
```

The docker build also works for compiling specific commits of a specific branch of a repository:

```
docker build -t heaa-ai-release . --build-arg repository=heaa-ai-release --build-arg branch=<branch_name> --build-arg tag=<commit_hash>
```

Note: To checkout a specific release/tag, pass the argument as `tags/<tag_id>` and not just the `<tag_id>`.

### Summary of the arguments to docker build:

- **repository**: refers to the repository to be built.
- **branch**: specific branch of the repository.
- **tag**: either the release tag (example tags/v1.10.6-dev) or specific commit hash.
- **CC_param**: only passed as argument if the compiler is clang-10.
- **CXX_param**: only passed as argument if the compiler is clang++-10.
- **no_threads**: argument to run make with as many threads.

## Running docker container with the docker image:

Once the image is built, run the container by using:

```
docker run -it --name heaa-ai <imagename>
```

example:

```
docker run -it --name heaa-ai heaa-ai
```

- the `-it` flag is used to run the container in interactive mode with a bash shell
- `--name` flag creates the docker container with name as heaa-ai.
- `-p` can be used to expose the port of the container to the host machine,
  example: ```docker run -it -p 80:80 --name heaa-ai heaa-ai```

## Running additional examples with docker heaa-ai installation:

The heaa-ai installation in the docker container can be used for running heaa-ai examples by mounting the examples
repository into the container with the `-v` flag. The following command runs a docker container and mounts the
heaa-ai-serial-examples folder into the docker container:

```
docker run -it -v ${PWD}/heaa-ai-serial-examples:/heaa-ai-serial-examples heaa-ai
```

Multiple terminals of the same container (that may be needed for client/server examples) can be run using

```
docker exec -it heaa-ai /bin/bash
```

## Clean up:

Type `exit` to leave the container shell.

To clean all containers once heaa-ai is done running

```
docker kill heaa-ai
docker container prune
```

To remove all the docker images and containers in the system, run

```
docker system prune
```

## Docker registry:

### Building and pushing

To build and push docker build to the registry, run the `upload-tagged-docker.sh` as

```
./upload-tagged-docker.sh -r <repository> -j <no_threads> -t <tag_id>
```

### Using the registry

1) Ensure `docker` is already installed. See [docker installation](https://docs.docker.com/engine/install/) to install.
2) Find the appropriate image in
   the [container registry](https://github.com/heaa-aiorg/heaa-ai/tree/main/docker).
    1) Click the copy icon on the right of the title
    2) If you hover over the copy icon it should be similar to this format `registry.example.com/group/project/image`
3) Specify an image name `imageName` then run

```
sudo docker run -dit --name imageName registry.example.com/group/project/image
```

where the `--name imageName` flag is the chosen image name.

4) Run

```
sudo docker exec -it imageName /bin/bash
```

where `imageName` is what was chosen above
