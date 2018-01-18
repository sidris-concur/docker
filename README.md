# Coding Dojo Docker example

This project contains a simple hello world Java web service that can be built and deployed in a Docker container. 

The project contains a `Dockerfile` that can be used to build the Docker container.

# Getting Started

Users can run this project via the [Coding Dojo Vagrant box](https://github.concur.com/sidris/vagrant), or on their local machines.

NOTE: you can also run the project on your local machine if you are have Docker installed locally. Docker can be installed on Linux, Mac OS, or Windows 10. Instructions for installing Docker can be found [here](https://docs.docker.com/engine/installation/). In addition to Docker, you will need to ensure that the following are installed and configured:

* git client
* Java SDK 8
* Docker

## Cloning the Docker project

Run the following command in your Coding Dojo Vagrant box, or on your local machine:

```
$ git clone git@github.concur.com:sidris/docker.git
```

## Useful Docker commands

### Create Docker Image

Run the following command in the directory containing a `Dockerfile`:

```
$ docker build -t helloimg .
```

### List local Docker Images 

Run the following command to list the Docker images available on a machine:

```
$ docker image ls -a
```

### Delete local Docker Image

```
$ docker image rm <imageid>
```

### Run Container

Once a `helloimg` image is created, run the following command:

```
$ docker run --name hello -d -p 5000:5000 helloimg 
```

### List Containers

Run the following command to see a list of running Docker containers

```
$ docker container ls
```

Run the following command to see a list of all Docker containers:

```
$ docker container ls -a
```

### Tail Container Logs

Run the following command to tail the logs of a given Docker container:

```
$ docker logs -f <name-or-hash>
```

### Stop Container

Run the following command to gracefully shutdown a Docker container:

```
$ docker container stop <name-or-hash>
```

Run the following command to forcefully shutdown a Docker container:

```
$ docker container kill <name-or-hash>
```

### Delete Container

Run the following command to delete a Docker container:

```
$ docker container rm <name-or-hash>
```

