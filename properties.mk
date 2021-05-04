#
# Properties for odessa
#

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.camera.physical.num=4

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.sf.color_mode=0

# Sensor
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.hardware.sensors=sofiar \
    ro.vendor.sensors.mot_ltv=true \
    ro.vendor.sensors.glance_approach=false
