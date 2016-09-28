#!/bin/zsh
#dockers=(centos-7 centos-6 ubuntu-14 ubuntu-16 docker-capture docker-viewer docker-wise)
dockers=(centos-7 centos-6 ubuntu-14 ubuntu-16)

# If running in release dir change to parent
if [ -f Dockerfile.centos-7 ]; then
    cd ..
fi

mkdir builds builds/centos-6 builds/centos-7 builds/ubuntu-14 builds/ubuntu-16

VERSION_CENTOS=`grep "AC_INIT(" configure.ac | sed 's/.*, \[\(.*\)\].*$/\1/' | tr "-" "_"`
VERSION_UBUNTU=`grep "AC_INIT(" configure.ac | sed 's/.*, \[\(.*\)\].*$/\1/'`

docker build --pull --file=release/Dockerfile.centos-6 --build-arg ITERATION=1 --build-arg VERSION=$VERSION_CENTOS .
docker build --pull --file=release/Dockerfile.centos-7 --build-arg ITERATION=1 --build-arg VERSION=$VERSION_CENTOS .
docker build --pull --file=release/Dockerfile.ubuntu-14 --build-arg ITERATION=1 --build-arg VERSION=$VERSION_UBUNTU .
docker build --pull --file=release/Dockerfile.ubuntu-16 --build-arg ITERATION=1 --build-arg VERSION=$VERSION_UBUNTU .

wait
