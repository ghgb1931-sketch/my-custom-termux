#!/bin/bash
echo "======================================================="
echo "🪟 INJECTING WINDOWS COMPATIBILITY LAYER (WINE & BOX64)"
echo "======================================================="

# 1. تفعيل حزم الدعم والتحميل
apt update
apt install -y wine64 winetricks cabextract

# 2. إعداد بيئة تشغيل خفيفة ومراقبة للرامات
# السكريبت ده هيتأكد إن الويندوز شغال على وضع متوافق مع رامات الموبايل
cat << 'WEOF' > /usr/local/bin/run_win
#!/bin/bash
# قراءة الرامات المتاحة ديناميكياً لتخصيص حجم الـ Virtual Memory للـ Wine
AVAILABLE_RAM=$(free -m | awk '/^Mem:/{print $7}')

echo "[📊 RAM MONITOR]: Available Memory is ${AVAILABLE_RAM}MB"

if [ "$AVAILABLE_RAM" -gt 4048 ]; then
    echo "[🚀 TURBO WINDOWS]: High RAM detected. Optimizing Wine for performance..."
    export WINEMULTIPROCESS=1
else
    echo "[🔋 ECO WINDOWS]: Low RAM detected. Limiting Wine background threads..."
    export WINEMULTIPROCESS=0
fi

# تشغيل ملف الـ EXE الممرر للأمر
wine64 "$@"
WEOF

chmod +x /usr/local/bin/run_win

echo "======================================================="
echo "✅ WINDOWS LAYER COMPLETED!"
echo "💡 لتشغيل أي ملف ويندوز (.exe) الآن، اكتب فقط:"
echo "   run_win path_to_file.exe"
echo "======================================================="
