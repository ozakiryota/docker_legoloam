#!/bin/bash

image="legoloam"
tag="latest"

docker build . \
    -t $image:$tag