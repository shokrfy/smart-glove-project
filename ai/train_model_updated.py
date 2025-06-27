import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
import tensorflow as tf
import matplotlib.pyplot as plt

# 1. تحميل البيانات
df = pd.read_csv("gesture_data.csv")

# 2. حذف الأعمدة غير المهمة
for col in ["Timestamp", "Temp"]:
    if col in df.columns:
        df = df.drop(columns=[col])

# 3. ترميز الحركات
le = LabelEncoder()
df["Gesture_Label"] = le.fit_transform(df["Gesture_Label"])

# 4. فصل البيانات
X = df.drop(columns=["Gesture_Label"])
y = df["Gesture_Label"]

# 5. تطبيع البيانات
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# 6. تقسيم البيانات
X_train, X_test, y_train_raw, y_test_raw = train_test_split(X_scaled, y, test_size=0.2, random_state=42)

# 7. تحويل y إلى one-hot
y_train = tf.keras.utils.to_categorical(y_train_raw)
y_test = tf.keras.utils.to_categorical(y_test_raw)

# 8. بناء النموذج
model = tf.keras.Sequential([
    tf.keras.layers.Input(shape=(X_train.shape[1],)),
    tf.keras.layers.Dense(128, activation='relu'),
    tf.keras.layers.Dropout(0.3),
    tf.keras.layers.Dense(64, activation='relu'),
    tf.keras.layers.Dropout(0.3),
    tf.keras.layers.Dense(32, activation='relu'),
    tf.keras.layers.Dense(y_train.shape[1], activation='softmax')
])

model.compile(optimizer='adam',
              loss='categorical_crossentropy',
              metrics=['accuracy'])

# 9. تدريب النموذج
history = model.fit(X_train, y_train, epochs=50, batch_size=16, validation_data=(X_test, y_test))

# 10. حفظ النموذج والـ labels
model.save("gesture_model.h5")
np.save("gesture_labels.npy", le.classes_)
print("[✓] Model saved as gesture_model.h5")
print("[✓] Labels saved as gesture_labels.npy")

# 11. رسم Confusion Matrix
y_pred = model.predict(X_test)
y_pred_classes = np.argmax(y_pred, axis=1)
y_true_classes = np.argmax(y_test, axis=1)

# التأكد من التطابق
labels_count = len(le.classes_)
cm = confusion_matrix(y_true_classes, y_pred_classes, labels=list(range(labels_count)))
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=le.classes_)

plt.figure(figsize=(10, 8))
disp.plot(xticks_rotation=45, cmap="Blues", values_format='d')
plt.title("Confusion Matrix")
plt.tight_layout()
plt.savefig("confusion_matrix.png")
print("[✓] Confusion matrix saved as confusion_matrix.png")
