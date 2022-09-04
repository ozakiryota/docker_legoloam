########## Pull ##########
FROM ros:melodic
########## Non-interactive ##########
ENV DEBIAN_FRONTEND=noninteractive
########## Common tool ##########
RUN apt-get update && \
	apt-get install -y \
		vim \
		wget \
		unzip \
		git \
        python-tk
########## ROS setup ##########
RUN mkdir -p ~/catkin_ws/src && \
	cd ~/catkin_ws && \
	/bin/bash -c "source /opt/ros/melodic/setup.bash; catkin_make" && \
	echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc && \
	echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc && \
	echo "export ROS_WORKSPACE=~/catkin_ws" >> ~/.bashrc
########## gstam ##########
RUN wget https://github.com/borglab/gtsam/archive/4.0.0-alpha2.zip -O /tmp/4.0.0-alpha2.zip && \
	unzip /tmp/4.0.0-alpha2.zip -d /tmp/ && \
	mkdir -p /tmp/gtsam-4.0.0-alpha2/build && \
	cd /tmp/gtsam-4.0.0-alpha2/build && \
	cmake .. && \
	make install -j $(nproc --all)
########## LeGO-LOAM ##########
## requirements
RUN apt-get update && \
	apt-get install -y \
		ros-melodic-tf \
		ros-melodic-cv-bridge \
		ros-melodic-image-transport \
		ros-melodic-pcl-ros \
		ros-melodic-rviz
## build
RUN cd ~/catkin_ws/src && \
	git clone https://github.com/RobustFieldAutonomyLab/LeGO-LOAM.git && \
	cd ~/catkin_ws && \
	/bin/bash -c "source /opt/ros/melodic/setup.bash; catkin_make -j $(nproc --all)"
## fix
RUN cd ~/catkin_ws/src/LeGO-LOAM && \
	grep -rl "\/camera_init" . | xargs sed -i 's/"\/camera_init"/"camera_init"/g' && \
	grep -rl "\/laser_odom" . | xargs sed -i 's/"\/laser_odom"/"laser_odom"/g' && \
	grep -rl "\/camera" . | xargs sed -i 's/"\/camera"/"camera"/g' && \
	grep -rl "\/aft_mapped" . | xargs sed -i 's/"\/aft_mapped"/"aft_mapped"/g' && \
	cd ~/catkin_ws && \
	/bin/bash -c "source /opt/ros/melodic/setup.bash; catkin_make -j $(nproc --all)"
########## Optional packages ##########
## Velodyne driver
RUN apt-get update && \
	apt-get install -y \
		ros-melodic-diagnostics \
		ros-melodic-roslint \
		libpcap-dev && \
	cd ~/catkin_ws/src && \
	git clone https://github.com/ros-drivers/velodyne.git && \
	cd ~/catkin_ws && \
	/bin/bash -c "source /opt/ros/melodic/setup.bash; catkin_make"
########## Initial position ##########
WORKDIR /root/catkin_ws
