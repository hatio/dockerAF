
# Build containers

Before attempting to build the containers, please ensure that you have **Docker** installed.
Installers can be found [here](https://www.docker.com/products/docker-desktop).

In Terminal, navigate to the root directory of the repo, `dockerAF`.
Type `docker build -t <container_tag> <directory_of_building_script>`
to build the container of interest. For instance, if you are interested in building the `afscov2-css` container:

    docker build -t afviro/afscov2-css 01-buildContainer/afscov2-css

The `-t afviro/afscov2-css` portion names the container *afviro/afscov2-css* (an action called tagging). The  `01-buildContainer/afscov2-css` portion tells Docker where the `Dockerfile` (the container building recipe) resides.

Check to see if your container is now in the list of images recognized by your system.

    docker image ls
    
    
You should see the container tag listed under REPOSITORY. You now have a container that you can use locally. But if you would like to share with others via [DockerHub](www.dockerhub.com), you will need a DockerHub account. A personal account is free.


## Sharing via DockerHub

After you have signed-up for a DockerHub account, follow the instructions in this [link](https://docs.docker.com/docker-hub/repos/).

For Virology, AFRIMS, we have created an account called [afviro](https://hub.docker.com/u/afviro).
Notice that we have tagged the image in the example above `afviro/afscov2-css` to conform with
`<hub-user>/<repo-name>`. The DockerHub repository for this container was pushed to the DockerHub server via the following code:

    docker push afviro/afscov2-css

