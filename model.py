import xarray as xr
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense, Dropout

dataset = xr.open_dataset('/Users/davidfarfancastro/Documents/PY/AGROSAT/g4.timeAvgMap.GPM_3IMERGDE_07_precipitation.20240828-20240831.125W_25N_67W_53N.nc')

precipitation = dataset['GPM_3IMERGDE_07_precipitation'].values  

print(f"Tamaño de los datos de precipitación: {precipitation.shape}")  

precipitation_flat = precipitation.reshape(precipitation.shape[0], -1)  

time = pd.date_range(start='2024-08-28', periods=precipitation.shape[0], freq='D')

data = pd.DataFrame(precipitation_flat)

scaler = MinMaxScaler()
scaled_data = scaler.fit_transform(precipitation_flat)

X = scaled_data
y = scaled_data[:, 0]  

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42)

X_train = X_train.reshape((X_train.shape[0], 1, X_train.shape[1]))
X_test = X_test.reshape((X_test.shape[0], 1, X_test.shape[1]))

model = Sequential()
model.add(LSTM(50, activation='relu', input_shape=(X_train.shape[1], X_train.shape[2])))
model.add(Dropout(0.2))
model.add(Dense(1))

model.compile(optimizer='adam', loss='mean_squared_error')

history = model.fit(X_train, y_train, epochs=10, batch_size=1, validation_data=(X_test, y_test))

test_loss = model.evaluate(X_test, y_test)
print(f'Loss on test set: {test_loss:.4f}')

plt.plot(history.history['loss'], label='Training Loss')
plt.plot(history.history['val_loss'], label='Validation Loss')
plt.title('Loss Curve')
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.legend()
plt.show()

predictions = model.predict(X_test)

y_test_descaled = scaler.inverse_transform(np.concatenate([y_test.reshape(-1, 1)], axis=1))[:, 0]
predictions_descaled = scaler.inverse_transform(np.concatenate([predictions], axis=1))[:, 0]

plt.plot(y_test_descaled, label='Actual Values')
plt.plot(predictions_descaled, label='Predicted Values', linestyle='--')
plt.title('Precipitation Predictions Comparison')
plt.legend()
plt.show()
