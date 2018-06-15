# Quick ROS Install

Instant install script for ROS on various versions of Ubuntu Linux

## Install ROS on Ubuntu

    wget https://raw.githubusercontent.com/PickNikRobotics/quick-ros-install/master/ros_install.sh && chmod 755 ros_install.sh && ./ros_install.sh kinetic


Note: you may need these basic dependencies if, for example, you are running in a Docker container:

    apt-get update && apt-get install wget lsb-release sudo -y

## Install ROS with Docker

The following documents how to use a Nvidia-ready Docker container. More [details](http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration).

### Install Docker

If you are running a recent version of Ubuntu (e.g. 14.04, 16.04) it can be as simple as:

    sudo apt-get install curl
    curl -sSL https://get.docker.com/ | sh
    sudo usermod -aG docker $(whoami)

And you will likely need to log out and back into your user account for the changes to take affect.

### Download Nvidia Docker Script

We'll use the same approach provided by the ROS MoveIt! project for providing GPU support:

    wget https://raw.githubusercontent.com/ros-planning/moveit/kinetic-devel/.docker/gui-docker gui-docker
    chmod +x gui-docker

### Run Docker

    ./gui-docker -it --rm ros:kinetic-ros-base /bin/bash

### Test Docker

    apt-get update
    apt-get install ros-kinetic-rviz -y
    rosrun rviz rviz
