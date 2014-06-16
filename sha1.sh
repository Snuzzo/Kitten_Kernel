#!/bin/bash -e

sha1sum arch/arm/boot/zImage > sha1
sed 's/......................$//' sha1 > sha2
