#!/bin/bash -eu

# The BSD License
# Copyright (c) 2018 PickNik Consulting
# Copyright (c) 2014 OROCA and ROS Korea Users Group

#set -x

function usage {
    # Print out usage of this script.
    echo >&2 "usage: $0 [ROS distro (default: kinetic)"
    echo >&2 "          [-h|--help] Print help message."
    exit 0
}
# Parse command line. If the number of argument differs from what is expected, call `usage` function.
OPT=`getopt -o h -l help -- $*`
if [ $# != 1 ]; then
    usage
fi
eval set -- $OPT
while [ -n "$1" ] ; do
    case $1 in
        -h|--help) usage ;;
        --) shift; break;;
        *) echo "Unknown option($1)"; usage;;
    esac
done

ROS_DISTRO=$1
ROS_DISTRO=${ROS_DISTRO:="kinetic"}

version=`lsb_release -sc`

echo "Checking the ubuntu version"
case $version in
  "saucy" | "trusty" | "vivid" | "wily" | "xenial")
  ;;
  *)
    echo "ERROR: This script will only work on Ubuntu Saucy(13.10) / Trusty(14.04) / Vivid / Wily / Xenial. Exit."
    exit 0
esac

# echo "Update & upgrade the package"
# sudo apt-get update
# sudo apt-get upgrade

relesenum=`grep DISTRIB_DESCRIPTION /etc/*-release | awk -F 'Ubuntu ' '{print $2}' | awk -F ' LTS' '{print $1}'`
if [ "$relesenum" = "14.04.2" ]
then
  echo "Your ubuntu version is $relesenum"
  echo "Intstall the libgl1-mesa-dev-lts-utopic package to solve the dependency issues for the ROS installation specifically on $relesenum"
  sudo apt-get install -y libgl1-mesa-dev-lts-utopic
else
  echo "Your ubuntu version is $relesenum"
fi

# echo "Installing chrony and setting the ntpdate"
# sudo apt-get install -y chrony
# sudo ntpdate ntp.ubuntu.com

echo "Add the ROS repository"
if [ ! -e /etc/apt/sources.list.d/ros-latest.list ]; then
  sudo sh -c "echo \"deb http://packages.ros.org/ros/ubuntu ${version} main\" > /etc/apt/sources.list.d/ros-latest.list"
fi

echo "Download the ROS keys"
roskey=`apt-key list | grep "ROS Builder"`
if [ -z "$roskey" ]; then
  #wget --quiet https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | sudo apt-key add -
  sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
fi

echo "Update & upgrade the package"
sudo apt-get update
sudo apt-get dist-upgrade -y

echo "Installing ROS"
sudo apt install -y \
     liburdfdom-tools \
     python-rosdep \
     python-rosinstall \
     python-bloom \
     python-rosclean \
     python-wstool \
     python-pip \
     python-catkin-lint \
     python-catkin-tools \
     python-rosinstall \
     ros-kinetic-desktop-full \
     ros-kinetic-rqt* \
     ros-kinetic-rosemacs

# Only init if it has not already been done before
if [ ! -e /etc/ros/rosdep/sources.list.d/20-default.list ]; then
  sudo rosdep init
fi
rosdep update

# echo "Setting the ROS evironment"
# sh -c "echo \"source /opt/ros/$ROS_DISTRO/setup.bash\" >> ~/.bashrc"
# sh -c "echo \"source ~/$name_catkinws/devel/setup.bash\" >> ~/.bashrc"
# sh -c "echo \"export ROS_MASTER_URI=http://localhost:11311\" >> ~/.bashrc"
# sh -c "echo \"export ROS_HOSTNAME=localhost\" >> ~/.bashrc"

echo "Done"

exec bash

exit 0
