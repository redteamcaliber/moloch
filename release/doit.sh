#!/bin/zsh
#dockers=(centos-7 centos-6 ubuntu-14 ubuntu-16 docker-capture docker-viewer docker-wise)
dockers=(centos-7 centos-6 ubuntu-14 ubuntu-16)

# If running in release dir change to parent
if [ -f Dockerfile.centos-7 ]; then
    cd ..
fi

# Get version info
ITERATION=1
VERSION_CENTOS=`grep "AC_INIT(" configure.ac | sed 's/.*, \[\(.*\)\].*$/\1/' | tr "-" "_"`
VERSION_UBUNTU=`grep "AC_INIT(" configure.ac | sed 's/.*, \[\(.*\)\].*$/\1/'`

# Make build dirs if not already there
mkdir builds builds/centos-6 builds/centos-7 builds/ubuntu-14 builds/ubuntu-16

# Build images
docker build -t moloch-centos-6 --pull --file=release/Dockerfile.centos-6 --build-arg ITERATION=$ITERATION --build-arg VERSION=$VERSION_CENTOS .
docker build -t moloch-centos-7 --pull --file=release/Dockerfile.centos-7 --build-arg ITERATION=$ITERATION --build-arg VERSION=$VERSION_CENTOS .
docker build -t moloch-ubuntu-14 --pull --file=release/Dockerfile.ubuntu-14 --build-arg ITERATION=$ITERATION --build-arg VERSION=$VERSION_UBUNTU .
docker build -t moloch-ubuntu-16 --pull --file=release/Dockerfile.ubuntu-16 --build-arg ITERATION=$ITERATION --build-arg VERSION=$VERSION_UBUNTU .

# Actually copy result of build
for i (centos-7 centos-6 ubuntu-14 ubuntu-16); do                                                                                                                                                                               ~/moloch.github
  docker run --rm -v ${PWD}/builds/${i}:/output:rw -u $(id -u) moloch-$i bash -c "cp -r /moloch[_-]* /output/"
done

# Build docker containers
docker build -t moloch-capture --pull --file=release/Dockerfile.capture --build-arg ITERATION=$ITERATION --build-arg VERSION=$VERSION_UBUNTU .
docker build -t moloch-viewer --pull --file=release/Dockerfile.viewer --build-arg ITERATION=$ITERATION --build-arg VERSION=$VERSION_UBUNTU .
docker build -t moloch-wise --pull --file=release/Dockerfile.wise --build-arg ITERATION=$ITERATION --build-arg VERSION=$VERSION_UBUNTU .


wait
