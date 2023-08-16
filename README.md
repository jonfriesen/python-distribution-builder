# python-distribution-builder
This script builds tgz Python distributions.

# Usage

1. Clone repository
2. `cd python-distribution-builder`
3. `docker run -it --rm -v .:/build ubuntu:bionic bash`
4. `cd /build`
5. `./build.sh <Python version, eg: 3.10.12>`
