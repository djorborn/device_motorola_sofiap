#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=sofiap
export DEVICE_COMMON=sm6125-common
export VENDOR=motorola

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"

MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

ANDROID_ROOT="$MY_DIR"/../../..
BLOB_ROOT="$ANDROID_ROOT"/vendor/"$VENDOR"/"$DEVICE"/proprietary

CAMERA_HAL_CHI="$BLOB_ROOT"/vendor/lib64/hw/com.qti.chi.override.so
sed -i "s/libhidltransport.so/qtimutex.so\x00\x00\x00\x00\x00\x00\x00\x00/" "$CAMERA_HAL_CHI"

CHARGE_ONLY="$BLOB_ROOT"/vendor/bin/charge_only_mode
for LIBMEMSET_SHIM in $(grep -L "libmemset_shim.so" "$CHARGE_ONLY"); do
    patchelf --add-needed "libmemset_shim.so" "$LIBMEMSET_SHIM"
done

VIDHANCE="$BLOB_ROOT"/vendor/lib64/libvidhance.so
CAMERA_HAL="$BLOB_ROOT"/vendor/lib64/hw/camera.qcom.so
LIBSSC="$BLOB_ROOT"/vendor/lib64/libssc.so
LIBSENSORCAL="$BLOB_ROOT"/vendor/lib64/libsensorcal.so
for LIBCOMPARETF2 in $(grep -L "libcomparetf2.so" "$VIDHANCE" "$CAMERA_HAL" "$LIBSSC" "$LIBSENSORCAL"); do
    patchelf --add-needed "libcomparetf2.so" "$LIBCOMPARETF2"
done

for LIBDEMANGLE in $(grep -L "libdemangle.so" "$VIDHANCE"); do
    patchelf --add-needed "libdemangle.so" "$LIBDEMANGLE"
done
