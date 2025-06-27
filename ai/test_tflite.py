import numpy as np
import pandas as pd
import tensorflow as tf          # أو import tflite_runtime.interpreter as tflite
from sklearn.preprocessing import StandardScaler

# ========== 1. تحميل البيانات الأصلية لحساب الـ Scaler ==========
df = pd.read_csv("gesture_data.csv")

# حذف الأعمدة غير المستخدمة
df = df.drop(columns=["Timestamp", "Temp", "Gesture_Label"])

# fit() على كل الداتا علشان نطبّق نفس الـ mean/std
scaler = StandardScaler().fit(df)

# ========== 2. تحميل اللابلز ==========
labels = np.load("gesture_labels.npy", allow_pickle=True)

# ========== 3. تجهيز Interpreter لـ TFLite ==========
interpreter = tf.lite.Interpreter(model_path="gesture_model.tflite")
interpreter.allocate_tensors()

input_details  = interpreter.get_input_details()[0]   # expect shape (1, 11)
output_details = interpreter.get_output_details()[0]  # shape (1, num_labels)

print(f"[✓] Model loaded. Input shape = {input_details['shape']}")

# ========== 4. اختيار عيّنة اختبار ==========
# خُذ أول صف من الداتا كمثال
raw_sample = df.iloc[0].to_numpy().astype(np.float32)

# أو أدخل القيم يدويًّا هكذا:
# raw_sample = np.array([3450,3700,3005,3350,4095,
#                        16200,-3500,-1200,-300,180,-400], dtype=np.float32)

# ========== 5. تطبيع العيّنة بنفس الـ StandardScaler ==========
scaled_sample = scaler.transform([raw_sample]).astype(np.float32)  # shape = (1,11)

# ========== 6. تنفيذ الاستدلال ==========
interpreter.set_tensor(input_details['index'], scaled_sample)
interpreter.invoke()
output = interpreter.get_tensor(output_details['index'])   # shape (1, N)

pred_idx = int(np.argmax(output))
pred_conf = float(output[0][pred_idx])

print(f"🔍 Predicted: {labels[pred_idx]}   |   Confidence: {pred_conf:.2%}")
# احضار اللابل الحقيقى لهذا الصف
true_label = pd.read_csv("gesture_data.csv")["Gesture_Label"].iloc[0]
print(f"✅ True label   : {true_label}")
print(f"🔍 Predicted    : {labels[pred_idx]} | Conf = {pred_conf:.2%}")
