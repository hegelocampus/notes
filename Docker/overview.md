### ~W16D3 reading notes
## Docker
- Docker packages your project into a `container` this container has all the dependencies of your project packaged into a standardized package that will be the same for any person running your app
### Containers
From the Docker website:
> A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another. A Docker container image is a lightweight, standalone, executable package of software that includes everything needed to run an application: code, runtime, system tools, system libraries and settings.
- A container uses the Kernel of the host operating system
- They have their own file system and IP
- Everything related to the app is installed inside the container
- Containers are super lightweight
- Docker is **not** a VM, containers are **not** VMs
- containers use the host kernel while VMs either interact with the kernel through the host OS or start a new instance of the kernel
- Containers and VMs are often paired in a production env
- Containers are "ephemeral", i.e., they can be stopped and destroyed and then rebuilt and replaced with minimum setup and config
### Persistent data
- If you want data to persist you will need to set it up to be stored within a volume
  - These are stored in the host filesystem
  - You can create a volume explicitly using `docker volume create`
  - Alternatively docker will create a volume if you run the container with `docker run -v /path/in/container`
- **Volumes are not tied to the container lifecycle**
- A volume can be mounted simultaneously onto multiple containers
- You can remove unused volumes using `docker volume prune`
### Networks
- **User-defined bridge networks are superior to the default bridge network.**
- Bridge setup example:
```bash
docker network create -driver bridge mybridge
docker container run -d --net mybridge --name db redis
docker container run -d --net mybridge -e DB=db -p 8000:5000 --name web chrch/web
```
### Images
- An image is > an ordered collection of root filesystem changes and the corresponding execution parameters for use within a container runtime
- Images are composed of metadata and **layers**
  - Each layer is a set of differences form the layer before it, similar to a git commit
- The lowest level of every image is a blank layer called `scratch`
- You can use `docker image inspect <foo>` to get information about an image
- `docker image history <foo>` will show you the history of the image's layers
### Dockerfiles
- A Dockerfile is a text file describing the build steps of a dev environment
- Dockerfile is a language unique to Docker
- The default name is `Dockerfile` although you can rename it
- `docker bulid .` builds an image from the `Dockerfile`
  - You can use `-t name:tag` to tag the newly built image
- Each instruction will create an image layer
Its  best practice to chain commands using `\` and `&&`
- This saves space by reducing the number of layers
- When a build is requested and nothing in the Dockerfile has changed since the last one then docker will use a cached version of the file to generate the new container
- Its a good idea to put any layers that may be changed as low in the Dockerfile as you are able
  - This allows earlier builds to still make use of the cache up until the changes
Example Dockerfile:
```dockerfile
FROM node:argon
# Create app directory
RUN mkdir -p /usr/src/app \

# These two stanzas are part of the same created RUN layer
# you can chain commands like this using '\' and '&&'
	&& echo "This is part of the same layer" \
	&& echo "and so is this one!"

# change our current working directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install

# Bundle app source
COPY . /usr/src/app

# expose a port
EXPOSE 8080

#  This is the command that will be run
# each time a container is built using this image
CMD [ "npm", "start" ]
```
You can enable logging in the dockerfile by telling the docker where it can put logs
e.g.,
```dockerfile
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/IMAGENAME/access.log \
	&& ln -sf /dev/stderr /var/log/IMAGENNAME/error.log
```
**Always specify the exact image version you want in your Dockerfile**
- The `latest` tag is the default tag applied when pulling or pushing an image
  - This is the latest stable release
