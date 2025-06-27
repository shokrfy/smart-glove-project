import serial
import numpy as np
import pandas as pd
import tensorflow as tf
from sklearn.preprocessing import StandardScaler

# ====== الإعدادات ======
SERIAL_PORT = 'COM3'      # ← غيّرها حسب جهازك
BAUD_RATE = 115200
EXPECTED_KEYS = ["Flex1", "Flex2", "Flex3", "Flex4", "Flex5", "AccX", "AccY", "AccZ", "GyroX", "GyroY", "GyroZ"]

# ====== تحميل النموذج ======
model = tf.keras.models.load_model("gesture_model.h5")
labels = np.load("gesture_labels.npy", allow_pickle=True)


# ====== إعداد Scaler بنفس التدريب ======
df = pd.read_csv("gesture_data.csv")
df = df.drop(columns=["Timestamp", "Temp"])
X = df.drop(columns=["Gesture_Label"])
scaler = StandardScaler()
scaler.fit(X)

# ====== فتح السيريال ======
try:
    ser = serial.Serial(SERIAL_PORT, BAUD_RATE)
    print(f"[✓] Connected to {SERIAL_PORT}")
except:
    print("[X] Couldn't connect to Serial.")
    exit()

print("\n🚀 Waiting for real-time gestures from glove...\n")

# ====== قراءة القيم والتنبؤ ======
while True:
    try:
        line = ser.readline().decode().strip()
        if not line or ":" not in line:
            continue

        parts = line.split(",")
        values = {}

        for part in parts:
            if ':' in part:
                key, val = part.split(":")
                if key in EXPECTED_KEYS:
                    values[key] = float(val.strip())

        if len(values) == len(EXPECTED_KEYS):
            input_list = [values[key] for key in EXPECTED_KEYS]
            input_array = np.array([input_list])
            input_scaled = scaler.transform(input_array)

            pred = model.predict(input_scaled)
            pred_index = np.argmax(pred)
            pred_label = labels[pred_index]
            confidence = pred[0][pred_index]

            print(f"🖐️ Gesture: {pred_label} | 🔍 Confidence: {confidence:.2%}")
    except Exception as e:
        print(f"[!] Error: {e}")
