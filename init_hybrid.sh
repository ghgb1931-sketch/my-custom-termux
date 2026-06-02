#!/bin/system/bin/sh
# سكريبت إقلاع النظام الهجين المستقل من النواة

echo "[🌀 ALPHA FRAME]: Initializing Hybrid Core..."

# 1. تحديد مسار النظام الهجين المعزول (الـ Rootfs اللي ضغطناه)
export ROOTFS_DIR="/data/hybrid_os"
export DISPLAY=:0
export XDG_RUNTIME_DIR=/tmp

# 2. ربط أنوية نظام الموبايل بجسم النظام الهجين (Chroot Mounting)
mount -o bind /dev $ROOTFS_DIR/dev
mount -t proc proc $ROOTFS_DIR/proc
mount -t sysfs sys $ROOTFS_DIR/sys
mount -o bind /tmp $ROOTFS_DIR/tmp

# 3. قراءة الرامات لتحديد طور التشغيل (Eco / Turbo) قبل إطلاق الواجهة
AVAILABLE_RAM=$(free -m | awk '/^Mem:/{print $7}')
if [ "$AVAILABLE_RAM" -gt 4048 ]; then
    echo "Mode: TURBO" > /tmp/os_mode
else
    echo "Mode: ECO" > /tmp/os_mode
fi

# 4. إطلاق خادم الشاشة الحيوية تلقائياً
# هنا بنشغل الـ X Server المدمج في الـ ROM مباشرة
Xwayland :0 -auth /tmp/gdm.auth -nolisten tcp &

# 5. الدخول الآمن جوه النظام الهجين وتشغيل واجهة XFCE4
chroot $ROOTFS_DIR /bin/bash -c "source /etc/profile && startxfce4"
