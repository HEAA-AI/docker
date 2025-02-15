#!/bin/bash
while getopts ":r:j:t:" OPTION
do
	case $OPTION in
		t)
			TAG=$OPTARG;;
		j)
			THREADS=$OPTARG;;
		r)
			REPOSITORY=$OPTARG;;

		\?)
			echo "Please use the -r tag to set a repository, -j tag to set the number of threads for make and -t flag to set a tag"
			exit
			;;
	esac
done

docker build -t $REPOSITORY . --build-arg no_threads=$THREADS --build-arg repository=$REPOSITORY --build-arg tag=$TAG
docker run -dit --name heaa-ai -p 80:80 $REPOSITORY
docker commit heaa-ai heaa-ai:$TAG
docker login registry.github.com
docker image tag heaa-ai:$TAG registry.github.com/heaa-darkpools/$REPOSITORY/$TAG:$TAG
docker push registry.github.com/heaa-darkpools/$REPOSITORY/$TAG:$TAG
