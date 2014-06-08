#!/bin/sh

#### FOR DEVELOPING ONLY DOES NOT CONTAIN 99kernel INIT SCRIPT TO CONFIG THE KERNEL. ASSUMES YOU ARE DOING A DIRTY FLASH ####

## time start ##

time_start=$(date +%s.%N)

# Number of jobs (usually the number of cores your CPU has (if Hyperthreading count each core as 2))
MAKE="4"

## Set compiler location to compile with linaro cortex a8
echo "Setting compiler location..."
export ARCH=arm
export CROSS_COMPILE=$HOME/android/system/prebuilt/linux-x86/toolchain/linaro-arm-cortex-a8/bin/arm-cortex_a8-linux-gnueabi-

## Build kernel using pyramid_defconfig
make pyramid_defconfig
make -j`grep 'processor' /proc/cpuinfo | wc -l` ARCH=arm
sleep 1

# Post compile tasks
echo "Copying compiled kernel and modules to Packages/out/"
echo "and building flashable zip"
sleep 1

     mkdir -p Packages/
     mkdir -p Packages/out/
     mkdir -p Packages/out/system/lib/modules/
     mkdir -p Packages/out/kernel/
     mkdir -p Packages/out/META-INF/

cp -a $(find . -name *.ko -print |grep -v initramfs) Packages/out/system/lib/modules/
cp -rf prebuilt-scripts/META-INF/ Packages/out/
cp -rf prebuilt-scripts/kernel_dir/* Packages/out/kernel/
cp arch/arm/boot/zImage Packages/out/kernel/

# build flashable zip
     export curdate=`date "+%m-%d-%Y"`
     cd Packages/out/
     zip -r ../pyramid-kernel-dev-$curdate.zip .
     echo "Deleting Temp files and folders...."
     cd ../../
     rm -rf Packages/out/

echo "Build Complete, Check Packages directory for flashable zip"
time_end=$(date +%s.%N)
echo -e "${BLDYLW}Total time elapsed: ${TCTCLR}${TXTGRN}$(echo "($time_end - $time_start) / 60"|bc ) ${TXTYLW}minutes${TXTGRN} ($(echo "$time_end - $time_start"|bc ) ${TXTYLW}seconds) ${TXTCLR}"


