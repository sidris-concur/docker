# Docker Workshop

This workshop is intended to be run using the [Coding Dojo Vagrant box](https://github.concur.com/sidris/vagrant). 

However, all instructions starting from step 3 can be run on any machine that has the `docker` cli, `Java JDK 8`, and a `git` client installed on it.

## 1. Get the latest Coding Dojo Vagrant box

The latest Coding Dojo Vagrant box is available from https://github.concur.com/sidris/vagrant.

For the following examples assume that the Vagrant project project will be cloned into the `~/projects` directory.

### Follow these instructions if you have NOT run the Coding Dojo Vagrant box before

Clone the Coding Dojo Vagrant box project:

```
$ cd ~/projects
$ git clone git@github.concur.com:sidris/vagrant.git
```

Start the Coding Dojo Vagrant box:

```
$ cd ~/projects/vagrant
$ vagrant up
```


### Follow these instructions if you have run the Coding Dojo Vagrant box before

Pull the project to get latest:

```
$ cd ~/projects/vagrant
$ git pull
```

Run the following command to provision the Vagrant box:

```
$ cd ~/projects/vagrant
$ vagrant provision
```

Re-provisioning the Vagrant box is necessary to ensure that the provisioning scripts are run again since they may have been updated.

## 2. Connect to the Vagrant box

Run the following command to connect to the Vagrant box:

```
$ cd ~/projects/vagrant
$ vagrant ssh
```

## 3. Cloning the Docker project

Run the following command from inside the Coding Dojo Vagrant box:

```
$ cd ~
$ mkdir projects
$ cd projects
$ git clone https://github.com/sidris-concur/docker.git
```

## 4. Build the App

The Docker Workshop comes with a project that builds a simple Java web app. Let's go ahead and build this app.

### 4.1. Run the Gradle build

Run the following command in the Coding Dojo Vagrant box:

```
$ cd docker
$ ./gradlew clean build
```

The above command will build build the Java source code and generate a jar file. Once completed, there should be a new `~/projects/docker/build/libs` directory that contains a `helloworld-0.1.0.jar` file. 

Run the following command to run the application directly:

```
$ cd ~/projects/docker
$ java -jar build/libs/helloworld-0.1.0.jar
```

### 4.2 Build the Docker Image

Now that the jar file is ready let's package it as a Docker image.

#### 4.2.2. Build Docker Image

Run the following command to build a Docker image (make sure that it is run from a directory that contains a `Dockerfile`):

```
$ docker build -t helloimg .
```

The above command will create a new Docker image based on the `Dockerfile` and tag it with `helloimg`.

#### 4.2.3. List Docker Images

The newly created Docker image should now be visible in the local Docker image registry.

Run the following command to list all the local Docker images:

```
$ docker image ls
```

The output should look something like this:

	REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
	helloimg            latest              2222b16beab5        13 seconds ago      96.5MB
	openjdk             8-jre-alpine        b1bd879ca9b3        8 days ago          82MB

## 5. Run the App

Now let's run the application from the Docker image we just created. 

### 5.1. Run Docker Image

Run the following command to run an instance of the newly created image:

```
$ docker run --name hello -d -p 80:5000 helloimg
```

* The `-d` flag runs the application detached in the background.
* The `-p` flag maps the machine port to the container port. This was done to illustrate the difference between what we `EXPOSE` and within the `Dockerfile` and what we `publish` using Docker.
* The `--name` flag is used to assign a name to the container. This name can be used when referring to this container using Docker commands.

NOTE: The above command will return a long container id and return you to the terminal.

### 5.2. List running Docker containers

Run the following command to view all the running containers:

```
$ docker container ls
```

The output should look something like this:

	CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                            NAMES
	fe56cfa5c5f9        helloimg            "java -jar hellowo..."   About a minute ago   Up About a minute   8080/tcp, 0.0.0.0:80->5000/tcp   hello

### 5.3. Check the Container Logs

Run the following command to check the application logs:

```
$ docker logs hello
```

### 5.4. Connecting to the Running Container via Interactive Shell

Run the following command to connect to the running container and execute an interactive shell:

```
$ docker exec -it hello /bin/sh
```

NOTE: the base image for our App is the lightweight Alpine Linux and it doesn't have the `bash` shell installed. Attempting to connect using `/bin/bash` would cause an error.

### 5.5. Stop the Container

We can stop the container using the following command:

```
$ docker container stop hello
```

### 5.6. List running Docker containers

Run the following command to view all the running containers:

```
$ docker container ls
```

The output should look something like this:

	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                              NAMES

The container no longer shows up in the list.

### 5.7. List all Docker containers

However, the container is still there. To view it we will need to list all containers.

Run the following command to list all Docker containers:

```
$ docker container ls -a
```

The output should look something like this:

	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                       PORTS               NAMES
	fe56cfa5c5f9        helloimg            "java -jar hellowo..."   2 minutes ago       Exited (143) 5 seconds ago                       hello

## 6. Share the Docker Image

Everything we have done so far has been on our local machine. Now that our Docker image is created, we can publish it to a Docker regsitry and make it available to others. 

A registry is a collection of repositories. A repository is collection of images. The `docker` CLI uses Docker's public registry by default. 

### 6.1. Log in to Docker Public Registry

In order to publish to Docker's public registry you will to sign up for an account at [cloud.docker.com](https://cloud.docker.com/). Make note of your username.

Run the following command to login to Docker public registry:

```
$ docker login
```

### 6.2. Tag the Docker image

The notation for associating a local image with a repository on a registy is `hostname:port/username/repository:tag`. If an explicit hostname is not specified Docker will publish to the Docker Public Registry.

Run the following command to add the a meaningful repository name and tag to our local Docker image:

```
$ docker tag helloimg sidris/hello:0.1.0
```

Run the following command to list the Docker images:

```
$ docker image ls
```

The output should look something like this:

	REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
	helloimg            latest              2222b16beab5        3 minutes ago       96.5MB
	sidris/hello        0.1.0               2222b16beab5        3 minutes ago       96.5MB
	openjdk             8-jre-alpine        b1bd879ca9b3        8 days ago          82MB

### 6.3. Push the Docker image to the Registry

Run the following command to push the Docker image to the registry: 

```
$ docker push sidris/hello:0.1.0
```

Since no hostname was provided in our tag the image is pushed to the Docker Public Regsitry. To view the published image go to https://hub.docker.com/r/sidris/hello/.

### 7. Pull and run the Docker Image from the Remote Repository

Once published the Docker image can now be run by any other users, or on any machine with Docker installed.

Run the following command to pull the Docker image:

```
$ docker run --name hello -d -p 80:5000 sidris/hello:0.1.0
```

No matter where `docker run` executes, it pulls the image, along with the base image and runs the application.
