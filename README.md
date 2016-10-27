# Archivist

## First Time Installation

Get and install [Docker](https://www.docker.com/products/docker).

If you are using Docker on Windows, make sure to [enable shared drives](https://docs.docker.com/docker-for-windows/#shared-drives). Check your tray for for the Docker icon, and select settings once you right click it.

In the project root build the containers and start them up:

    docker-compose up --build

Initialize the database:

    docker-compose run website rake db:create db:setup

If you go to [localhost:3000](localhost:3000) you should be able to see the website.

## Usage/Administration

Changes made to the project locally will be immediately be applied upon refreshing the webpage. Changing the initialization scripts will require you to kill it then execute `docker-compose up` again.

To stop the containers `CTRL-C` on the terminal running them, then execute:

    docker-compose stop

If you did not see something like this:

    Stopping archivist-api_website_1 ...
	Stopping archivist-api_mongodb_1 ...
	Killing archivist-api_website_1 ... done
	Killing archivist-api_mongodb_1 ... done

The Rails logs can be viewed in the terminal where you ran `docker-compose up`.

You can access the Rails interactive console with:

    docker-compose run website rails c

You can run the unit tests with:

    docker-compose run website rake test

To freeup diskspace use:

    docker rmi -f $(docker images -qf dangling=true)
    docker volume rm $(docker volume ls -qf dangling=true)

Which is useful if you are rebuilding the containers a lot.

To run static analysis tasks:

    sudo docker-compose run website rake static_analysis
