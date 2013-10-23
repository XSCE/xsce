#!/bin/bash

yum install -y git ansible
git clone https://github.com/XSCE/xsce
pushd xsce
./runansible
popd
