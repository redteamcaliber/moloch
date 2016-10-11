#!/bin/bash
# If running in release dir change to parent
if [ -f Dockerfile.centos-7 ]; then
    cd ..
fi

# Download thirdparty stuff if we need to
release/download.sh

# Get version info
export NAME=${NAME:-moloch}
export ITERATION=${ITERATION:-1}
export VERSION_CENTOS=${VERSION_CENTOS:-`grep "AC_INIT(" configure.ac | sed 's/.*, \[\(.*\)\].*$/\1/' | tr "-" "_"`}
export VERSION_UBUNTU=${VERSION_UBUNTU:-`grep "AC_INIT(" configure.ac | sed 's/.*, \[\(.*\)\].*$/\1/'`}

# Make build dirs if not already there
mkdir builds builds/centos-6 builds/centos-7 builds/ubuntu-14 builds/ubuntu-16

# Build images
docker build -t moloch-centos-6 --pull --file=release/Dockerfile.centos-6 --build-arg ITERATION=$ITERATION --build-arg VERSION=$VERSION_CENTOS --build-arg NAME=$NAME .
docker build -t moloch-centos-7 --pull --file=release/Dockerfile.centos-7 --build-arg ITERATION=$ITERATION --build-arg VERSION=$VERSION_CENTOS --build-arg NAME=$NAME .
docker build -t moloch-ubuntu-14 --pull --file=release/Dockerfile.ubuntu-14 --build-arg ITERATION=$ITERATION --build-arg VERSION=$VERSION_UBUNTU --build-arg NAME=$NAME .
docker build -t moloch-ubuntu-16 --pull --file=release/Dockerfile.ubuntu-16 --build-arg ITERATION=$ITERATION --build-arg VERSION=$VERSION_UBUNTU --build-arg NAME=$NAME .

# Actually copy result of build
for i in centos-7 centos-6 ubuntu-14 ubuntu-16; do
  docker run --rm -v ${PWD}/builds/${i}:/output:rw -u $(id -u) moloch-$i bash -c "cp -r /$NAME[_-]* /output/"
done

# Build docker containers
docker build -t moloch-capture --pull --file=release/Dockerfile.capture --build-arg ITERATION=$ITERATION --build-arg VERSION=$VERSION_UBUNTU --build-arg NAME=$NAME .
docker build -t moloch-viewer --pull --file=release/Dockerfile.viewer --build-arg ITERATION=$ITERATION --build-arg VERSION=$VERSION_UBUNTU --build-arg NAME=$NAME .
docker build -t moloch-wise --pull --file=release/Dockerfile.wise --build-arg ITERATION=$ITERATION --build-arg VERSION=$VERSION_UBUNTU --build-arg NAME=$NAME .


wait
