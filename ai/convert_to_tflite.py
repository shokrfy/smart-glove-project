import tensorflow as tf
import numpy as np

# تحميل النموذج المدرب
model = tf.keras.models.load_model("gesture_model.h5")

# تحويل النموذج إلى TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# حفظ النموذج الجديد
with open("gesture_model.tflite", "wb") as f:
    f.write(tflite_model)
print("[✓] TFLite model saved as gesture_model.tflite")

# تحميل أسماء الحركات
labels = np.load("gesture_labels.npy", allow_pickle=True)


# حفظها كـ txt علشان Flutter يقرأها
with open("gesture_labels.txt", "w") as f:
    for label in labels:
        f.write(f"{label}\n")
print("[✓] Labels saved as gesture_labels.txt")
