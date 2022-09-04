#!/bin/bash

xhost +

image="legoloam"
tag="latest"

docker run \
	-it \
	--rm \
	-e "DISPLAY" \
	-v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--gpus all \
	-e NVIDIA_VISIBLE_DEVICES=all \
	-e NVIDIA_DRIVER_CAPABILITIES=all \
	--net=host \
	--privileged \
	-v $HOME/rosbag:/root/rosbag \
	-v $(pwd)/mount/demo.launch:/root/catkin_ws/src/LeGO-LOAM/LeGO-LOAM/launch/demo.launch \
	-v $(pwd)/mount/minimum_run.launch:/root/catkin_ws/src/LeGO-LOAM/LeGO-LOAM/launch/minimum_run.launch \
	-v $(pwd)/mount/utility.h:/root/catkin_ws/src/LeGO-LOAM/LeGO-LOAM/include/utility.h \
	$image:$tag \
	bash -c " \
		rm build/catkin_make.cache ;
		source ~/catkin_ws/devel/setup.bash ;
		cd ~/catkin_ws ;
		catkin_make ;
		roslaunch lego_loam demo.launch"