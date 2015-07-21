#!/bin/bash
#
# Simple script to resize the writable paritition of a Ubuntu Snappy system
# to the maximum possible value of the underlaying storage device.
#
# Author  : Simon Eisenmann <simon@struktur.de>
# License : BSD-3-Clause http://opensource.org/licenses/BSD-3-Clause
#
# Copyright (c) 2015, struktur AG
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

set -e
DEVNAME=$(blkid -L writable)
echo DEVNAME=$DEVNAME
DEV=$(basename $DEVNAME)
echo DEV=$DEV
BLOCKPATH=/sys/class/block/$DEV
echo BLOCKPATH=$BLOCKPATH
PARTITION=$(cat $BLOCKPATH/partition)
echo PARTITION=$PARTITION
REALPATH=$(realpath $BLOCKPATH)
echo REALPATH=$REALPATH
PARENTPATH=$(dirname $REALPATH)
echo PARENTPATH=$PARENTPATH
BLK=$(cat $PARENTPATH/dev)
echo BLK=$BLK
BLKDEV=$(realpath /dev/block/$BLK)
echo BLKDEV=$BLKDEV
set +e
growpart --fudge 20480 -u auto $BLKDEV $PARTITION
resize2fs $DEVNAME
