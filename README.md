# archivist-api

## Administration

These commands are run from your [`./archivist-docker`](https://github.com/ArchivistProject/archivist-docker) directory.

You can access the Rails interactive console with:

    docker-compose run api rails c

You can run the unit tests with:

    docker-compose run api rake test

To run static analysis on the code:

    sudo docker-compose run api rake static_analysis
