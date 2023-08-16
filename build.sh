#!/bin/bash

# Check if a version argument was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <python-version>"
    exit 1
fi

PYTHON_VERSION=$1
MAJOR_VERSION=$(echo $PYTHON_VERSION | cut -d. -f1)
MINOR_VERSION=$(echo $PYTHON_VERSION | cut -d. -f2)
SHORT_VERSION="$MAJOR_VERSION.$MINOR_VERSION"

INSTALL_DIR="/tmp/python-$PYTHON_VERSION"
TARBALL_NAME="python-$PYTHON_VERSION.tar.gz"
CURRENT_DIR=$(pwd)

# Install required dependencies
apt update
apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget

# Download Python source code
wget "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz"
tar -xvf "Python-$PYTHON_VERSION.tgz"
cd "Python-$PYTHON_VERSION"

# Configure the build with a prefix
./configure --prefix=$INSTALL_DIR --enable-optimizations

# Compile and install
make -j $(nproc)
make install

# Create a relative symbolic link for python to python3.x in the bin directory
cd $INSTALL_DIR/bin
ln -s python$SHORT_VERSION python

# Package the installation
cd /tmp
tar -czvf $TARBALL_NAME "python-$PYTHON_VERSION/"

# Move the tarball to the directory where the script was run from
mv $TARBALL_NAME $CURRENT_DIR

# Cleanup: Remove the downloaded .tgz file and the unzipped folder
rm -rf "/tmp/Python-$PYTHON_VERSION" "/tmp/Python-$PYTHON_VERSION.tgz" $INSTALL_DIR

echo "Python $PYTHON_VERSION has been packaged as $TARBALL_NAME in $CURRENT_DIR"
