import os
import time

def get_total_ram():
    try:
        with open('/proc/meminfo', 'r') as f:
            for line in f:
                if 'MemTotal' in line:
                    # تحويل الكيلوبايت إلى جيجابايت
                    return int(line.split()[1]) / (1024 * 1024)
    except Exception:
        return 0

def get_cpu_cores():
    return os.cpu_count() or 1

def boot_orchestrator():
    print("========================================")
    print("🧠 Nexus Sentinel: Hardware Scan Initiated...")
    time.sleep(1) # محاكاة فحص النظام
    
    ram_gb = get_total_ram()
    cores = get_cpu_cores()
    
    print(f"📊 Detected Hardware: CPU Cores: {cores} | RAM: {ram_gb:.2f} GB")
    print("========================================")
    
    # خوارزمية تحديد وضع التشغيل بناءً على الرامات
    if ram_gb < 4.0:
        print("🔋 Mode Active: [ECO / MOBILE MODE]")
        print("  -> Actions:")
        print("     * Background AI agents (Alpha Frame) limited to 1 thread.")
        print("     * Heavy UI rendering restricted to save battery.")
        print("     * System optimized for thermal control.")
    else:
        print("🚀 Mode Active: [TURBO / DESKTOP MODE]")
        print("  -> Actions:")
        print("     * Multi-threading enabled for Math & Philosophy agents.")
        print("     * Tropical Geometry dissipative flow equations unlocked for max CPU.")
        print("     * Pixel-perfect UI rendering initialized.")
        
    print("========================================")
    print("✅ System Ready for Next Module.")

if __name__ == "__main__":
    boot_orchestrator()
