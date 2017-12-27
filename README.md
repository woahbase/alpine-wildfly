[![Build Status](https://travis-ci.org/woahbase/alpine-wildfly.svg?branch=master)](https://travis-ci.org/woahbase/alpine-wildfly)

[![](https://images.microbadger.com/badges/image/woahbase/alpine-wildfly.svg)](https://microbadger.com/images/woahbase/alpine-wildfly)

[![](https://images.microbadger.com/badges/commit/woahbase/alpine-wildfly.svg)](https://microbadger.com/images/woahsbase/alpine-wildfly)

[![](https://images.microbadger.com/badges/version/woahbase/alpine-wildfly.svg)](https://microbadger.com/images/woahbase/alpine-wildfly)

## Alpine-WildFly
#### Container for Alpine Linux + Wildfly(JBoss) Server

---

This [image][8] serves as the server for applications / services
that require a [Wildfly][13] server running under [OpenJDK][12] 8.\*.\*.

Current released version is `11.0.0.Final`.

Built from my [alpine-openjdk:*_8][9] image with the [s6][10] init system
and GNU LibC [overlayed][11] in it.

* Default administration credentials are : `admin` : `insecurebydefault`.

* For standalone usage, only needed to mount the `deployments`
  directory with the WAR/JAR files, optionally `standalone.xml` if
  there are specifications. For the latter and if additional libs
  are needed, rebind the `lib` directory as well.

* the `SERVERCONFIG` environment variable which configuration to
  use inside the configuration directory, the `PASSWORD`
  environment variable specifies the default administrator
  password.

The image is tagged respectively for the following architectures,
* **armhf**
* **x86_64**

**armhf** builds have embedded binfmt_misc support and contain the
[qemu-user-static][5] binary that allows for running it also inside
an x64 environment that has it.

---
#### Get the Image
---

Pull the image for your architecture it's already available from
Docker Hub.

```
# make pull
docker pull woahbase/alpine-wildfly:x86_64

```

---
#### Run
---

If you want to run images for other architectures, you will need
to have binfmt support configured for your machine. [**multiarch**][4],
has made it easy for us containing that into a docker container.

```
# make regbinfmt
docker run --rm --privileged multiarch/qemu-user-static:register --reset

```
Without the above, you can still run the image that is made for your
architecture, e.g for an x86_64 machine..

```
# make
docker run --rm -it \
  --name docker_wildfly --hostname wildfly \
  -e PGID=100 -e PUID=1000 \
  -e PASSWORD=insecurebydefault \
  -e SERVERCONFIG=standalone.xml \
  -p 8080:8080 -p 9990:9990 \
  -v deployments:/opt/jboss/wildfly/standalone/deployments \
  -v /etc/localtime:/etc/localtime:ro \
  woahbase/alpine-wildfly:x86_64

# make stop
docker stop -t 2 docker_wildfly

# make rm
# stop first
docker rm -f docker_wildfly

# make restart
docker restart docker_wildfly

```

---
#### Shell access
---

```
# make rshell
docker exec -u root -it docker_wildfly /bin/bash

# make shell
docker exec -it docker_wildfly /bin/bash

# make logs
docker logs -f docker_wildfly

```

---
## Development
---

If you have the repository access, you can clone and
build the image yourself for your own system, and can push after.

---
#### Setup
---

Before you clone the [repo][7], you must have [Git][1], [GNU make][2],
and [Docker][3] setup on the machine.

```
git clone https://github.com/woahbase/alpine-wildfly
cd alpine-wildfly

```
You can always skip installing **make** but you will have to
type the whole docker commands then instead of using the sweet
make targets.

---
#### Build
---

You need to have binfmt_misc configured in your system to be able
to build images for other architectures.

Otherwise to locally build the image for your system.

```
# make ARCH=x86_64 JVVMAJOR=8 build
# sets up binfmt if not x86_64
docker build --rm --compress --force-rm \
  --no-cache=true --pull \
  -f ./Dockerfile_x86_64 \
  -t woahbase/alpine-wildfly:x86_64 \
  --build-arg ARCH=x86_64 \
  --build-arg DOCKERSRC=alpine-openjdk \
  --build-arg USERNAME=woahbase \
  --build-arg JVVMAJOR=8 \
  --build-arg WFVERSION=10.1.0.Final \
  --build-arg PUID=1000 \
  --build-arg PGID=1000

# make ARCH=x86_64 test
docker run --rm -it \
  --name docker_wildfly --hostname wildfly \
  --entrypoint=/opt/jboss/wildfly/bin/jboss-cli.sh \
  woahbase/alpine-wildfly:x86_64 \
  version

# make ARCH=x86_64 push
docker push woahbase/alpine-wildfly:x86_64

```

---
## Maintenance
---

Built at Travis.CI (armhf / x64 builds). Docker hub builds maintained by [woahbase][6].

[1]: https://git-scm.com
[2]: https://www.gnu.org/software/make/
[3]: https://www.docker.com
[4]: https://hub.docker.com/r/multiarch/qemu-user-static/
[5]: https://github.com/multiarch/qemu-user-static/releases/
[6]: https://hub.docker.com/u/woahbase

[7]: https://github.com/woahbase/alpine-wildfly
[8]: https://hub.docker.com/r/woahbase/alpine-wildfly
[9]: https://hub.docker.com/r/woahbase/alpine-openjdk

[10]: https://skarnet.org/software/s6/
[11]: https://github.com/just-containers/s6-overlay
[12]: http://openjdk.java.net/
[13]: http://wildfly.org/
