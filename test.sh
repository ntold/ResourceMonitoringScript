#!/bin/bash

dd if=/dev/zero bs=10 | bzip2 -9 > /tmp/file.out.bz2 &
