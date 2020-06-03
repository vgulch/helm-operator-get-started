#!/usr/bin/env bash

repository="stefanprodan/podinfo"
repository_my="vgulch/podinfo"
branch="master"
version=""
commit=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1 | awk '{print tolower($0)}')

while getopts :r:b:v: o; do
    case "${o}" in
        r)
            repository=${OPTARG}
            ;;
        b)
            branch=${OPTARG}
            ;;
        v)
            version=${OPTARG}
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${version}" ]; then
    image="${repository}:${branch}-${commit}"
    image_my="${repository_my}:${branch}-${commit}"
    version="0.4.0"
else
    image="${repository}:${version}"
    image_my="${repository_my}:${version}"
fi

echo ">>>> Building image ${image} <<<<"

docker build --build-arg GITCOMMIT=${commit} --build-arg VERSION=${version} -t ${image} -f Dockerfile.ci .

docker image tag ${image} ${image_my}
docker push ${image_my}
