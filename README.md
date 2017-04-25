## Short Description

Glare is an OpenStack project that provides unified catalog of binary data along with its metadata, such strauctures are also called 'artifacts'. This project aim to deploy Glare service using Docker and can be upgraded easily.

## Quick Start

For the impatient, I simplify some boring step using `Makefile`.

### 1. Build the image

```bash
git clone https://github.com/Fedosin/docker-glare.git
cd docker-glare
make
```

### 2. Start The Glare Service

```bash
make run
```

You can use `make log` to track log and `make exec` to enter instance context using shell.

### 3. Remove Glare container

```bash
make clean
```

## Quick Start Using Docker Compose

If you want to use docker-compose you can simply run:

```docker-compose up -d```

## How to use this image

Openstack Glare Service uses an SQL database (default sqlite) to store data. The official documentation recommends use MariaDB or MySQL.

```bash
docker run -d -e MYSQL_ROOT_PASSWORD=MYSQL_DBPASS -h mysql --name some-mysql -d mariadb
```

Start your Glare Service :

```bash
docker run --name glare --hostname controller --link some-mysql:mysql -p 9494:9494  -d mfedosin/openstack-glare
```

The following environment variables should be change according to your practice.

* `-e MYSQL_ROOT_PASSWORD=...`: Defaults to the value of the `MYSQL\_ROOT\_PASSWORD` environment variable from the linked mysql container.
* `-e MYSQL_HOST=...`: If you use an external database, specify the address of the database. Defaults to "mysql".

It may takes seconds to do some initial work, you can use `docker logs` to detect the progress. Once the OpenStack Glare Service is started, you can verify operation of the Artifact service as follows:

```
docker exec -t -i glare bash
cd /root
source openrc
glare create image my_img
glare list images
```
