docker-reviewboard
==================

Dockerized reviewboard. This container follows Docker's best practices, and DOES NOT include sshd, supervisor, apache2, or any other services except the reviewboard itself which is run with ```uwsgi```.

The requirements are PostgreSQL and memcached, you can use either dockersized versions of them, or external ones, e.g. installed on the host machine, or even third-party machines.

## Quickstart. Run dockerized reviewboard with all dockerized dependencies, and persistent data in a docker container.

    make  # if you want to build the image yourself
    make run

    # Go to http://127.0.0.1:8000/ (or your docker host) and login as admin:admin

Alternatively, here are the commands to do the same manually.

    # Create a data container for reviewboard with ssh credentials, media and PostgreSQL data.
    docker create -v /root/.ssh -v /media -v /var/lib/postgresql/data --name rb-data busybox true

    # Install postgres
    docker run -d --name rb-postgres --volumes-from rb-data -e POSTGRES_USER=reviewboard postgres

    # Install memcached
    docker run --name rb-memcached -d memcached memcached -m 2048

    # Run reviewboard
    docker run -it --name rb-server --link rb-postgres:pg --link rb-memcached:memcached --volumes-from rb-data -p 8000:8000 ikatson/reviewboard

After that, go the url, e.g. ```http://localhost:8000/```, login as ```admin:admin```, change the admin password, and change the location of your SMTP server so that the reviewboard can send emails. You are all set!

For details, read below.

## Build yourself if you want.

If you want to build this yourself, just run this:

    docker build -t 'ikatson/reviewboard' git://github.com/ikatson/docker-reviewboard.git

## Dependencies

### Install PostgreSQL

You can install postgres either into a docker container, or whereever else.

1. Example: install postgres into a docker container, and create a database for reviewboard.

        docker run -d --name rb-postgres --volumes-from rb-data -e POSTGRES_USER=reviewboard postgres
    
    You need to backup PostgreSQL data to a volume, in order to preserve it over

2. Example: install postgres into the host machine, example given for a Debian/Ubuntu based distribution.

        apt-get install postgresql-server

        # Uncomment this to make postgres listen on all addresses.
        # echo "listen_addresses = '*'" >> /etc/postgresql/VERSION/postgresql.conf
        # invoke-rc.d postgresql restart
        sudo -u postgres createuser reviewboard
        sudo -u postgres createdb reviewboard -O reviewboard
        sudo -u postgres psql -c "alter user reviewboard set password to 'SOME_PASSWORD'"

### Install memcached

1. Example: install into a docker container

        docker run --name memcached -d memcached memcached -m 2048
    
    Reviewboard documentation suggests to set at least 2GB of RAM to memcached

1. Example: install locally on Debian/Ubuntu.

        apt-get install memcached

   Don't forget to make it listen on needed addresses by editing /etc/memcached.conf, but be careful not to open memcached for the whole world.

## Run reviewboard

This container has two volume mount-points:

- ```/root/.ssh``` - The default path to where reviewboard stores it's ssh keys.
- ```/media``` - The default path to where reviewboard stores uploaded media.

The container accepts the following environment variables:

- ```PGHOST``` - the postgres host. Defaults to the value of ```PG_PORT_5432_TCP_ADDR```, provided by the ```pg``` linked container.
- ```PGPORT``` - the postgres port. Defaults to the value of ```PG_PORT_5432_TCP_PORT```, provided by the ```pg``` linked container, or 5432, if it's empty.
- ```PGUSER``` - the postgres user. Defaults to ```reviewboard```.
- ```PGDB``` - the postgres database. Defaults to ```reviewboard```.
- ```PGPASSWORD``` - the postgres password. Defaults to ```reviewboard```.
- ```MEMCACHED``` - memcache address in format ```host:port```. Defaults to the value from linked ```memcached``` container.
- ```DOMAIN``` - defaults to ```localhost```.
- ```DEBUG``` - if set, the django server will be launched in debug mode.

Also, uwsgi accepts environment prefixed with ```UWSGI_``` for it's configuration
E.g. ```-e UWSGI_PROCESSES=10``` will create 10 reviewboard processes.

### Example. Run with dockerized postgres and memcached from above, expose on port 8000:

    # Create a data container.
    docker create -v /root/.ssh -v /media --name rb-data busybox true
    docker run -it --name rb-server --link rb-postgres:pg --link memcached:memcached --volumes-from rb-data -p 8000:8000 ikatson/reviewboard

### Example. Run with postgres and memcached installed on the host machine.

    DOCKER_HOST_IP=$( ip addr | grep 'inet 172.1' | awk '{print $2}' | sed 's/\/.*//')

    # Create a data container.
    docker create -v /root/.ssh -v /media --name rb-data busybox true
    docker run -it --name rb-server -p 8000:8080 --volumes-from rb-data -e PGHOST="$DOCKER_HOST_IP" -e PGPASSWORD=123 -e PGUSER=reviewboard -e MEMCACHED="$DOCKER_HOST_IP":11211 ikatson/reviewboard

Now, go to the url, e.g. ```http://localhost:8000/```, login as ```admin:admin``` and change the password. The reviewboard is almost ready to use!

### Container SMTP settings.

You should also change SMTP settings, so that the reviewboard can send emails. A good way to go is to set this to docker host's internal IP address, usually, ```172.17.42.1```).

Don't forget to setup you mail agent to accept emails from docker.

For example, if you use ```postfix```, you should change ```/etc/postfix/main.cf``` to contain something like the lines below:

    mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 172.17.0.0/16
    inet_interfaces = 127.0.0.1,172.17.42.1
