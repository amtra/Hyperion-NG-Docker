![Hyperion](https://github.com/hyperion-project/hyperion.ng/blob/master/doc/logo_dark.png?raw=true#gh-dark-mode-only)
![Hyperion](https://github.com/hyperion-project/hyperion.ng/blob/master/doc/logo_light.png?raw=true#gh-light-mode-only)

## **Original work by [psychowood](https://github.com/psychowood/hyperion.ng-docker)**

This is a repository which is modified by me for my need. I removed nighty builds as per my need. If you want to explore more please visit [psychowood](https://github.com/psychowood/hyperion.ng-docker) 

As per psychowood
1. It's based on the [official Debian 11 (bullseye) docker image](https://hub.docker.com/_/debian)
2. It downloads the hyperion official package from the [official hyperion apt package repository](https://apt.hyperion-project.org/)
3. Maps the `/config` dirctory as an external volume, to keep your settings
4. Runs hyperiond service as non-root user. Default UID:GID are 1000:1000 but they can be easily changed adding a `.env` file

The setup is done on first run. 

Sadly, the resulting image is not exaclty slim at ~500MB, because hyperion has lots of dependencies. Since many of them are for the Desktop/Qt UI, it should be possible to slim the image up by cherry picking the ones not used but the cli service, but that's probably not really worth it.

On the other hand, the running service does not need lots of RAM (on my system takes ~64MB without the cache).

You have different options to run this image, after starting the container you can reach the web ui going either to http://youdockerhost:8090 or https://youdockerhost:8092

### Build Steps

Simply said: git clone the repo (or directly download the Dockerfile)

```sh
git clone https://github.com/amtra/Hyperion-NG-Docker
```
docker build the local image
```sh
docker build -t hyperionng --no-cache .
```
start the container with `docker compose up -d` with the following `docker-compose.yml` file (included in the repo):
```yaml
version: '3.3'

services:
  hyperionng:
    image: hyperionng:latest
    container_name: hyperionng
    volumes:
      - hyperionng-config:/config
    ports:
      - "19400:19400"
      - "19444:19444"
      - "19445:19445"
      - "8090:8090"
      - "8092:8092"
    restart: unless-stopped
volumes:
  hyperionng-config:
```
You may want to adapt the "ports" section adding other port mappings for specific cases (e.g. "2100:2100/udp" for Philips Hue in Entertainment mode).

Moreover, if you want to use some hardware devices (USB. serial, video, and so on), you need to passthrough the correct one adding a devices section in the compose file (the following is jut an example):

```yaml
devices:
      - /dev/ttyACM0:/dev/ttyACM0
      - /dev/video1:/dev/video1
      - /dev/ttyUSB1:/dev/ttyUSB0
      - /dev/spidev0.0:/dev/spidev0.0 
```

If you want to use different UID and GID, you can add a `.env` file in the same folder of your `docker-compose.yml` file:

```properties
UID=1100
GID=1100
```
