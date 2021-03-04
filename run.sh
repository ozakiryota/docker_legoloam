#!/bin/bash

image_name="legoloam"

docker run -it --rm \
	--net=host \
	$image_name:latest
