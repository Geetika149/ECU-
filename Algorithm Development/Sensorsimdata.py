import numpy as np
import matplotlib.pyplot as plt

def analyzeEngineCondition(temp, pressure, rpm):
    # Define thresholds
    normalRange = [600, 1000]  # Temperature range for normal condition
    overheatingThreshold = 1000  # Overheating temperature threshold
    highPressureThreshold = 400  # High pressure threshold
    lowPressureThreshold = 200  # Low pressure threshold

    # Analyze sensor data and determine engine condition
    if temp > overheatingThreshold:
        engineCondition = 'Overheating'
    elif pressure < lowPressureThreshold:
        engineCondition = 'Low Pressure'
    elif pressure > highPressureThreshold:
        engineCondition = 'High Pressure'
    elif temp < normalRange[0] or temp > normalRange[1] or rpm < 20000 or rpm > 100000:
        engineCondition = 'Abnormal'
    else:
        engineCondition = 'Normal'

    # Determine fuel rate adjustment based on engine condition
    if engineCondition == 'Overheating' or engineCondition == 'Low Pressure':
        fuelRateAdjustment = -0.1  # Reduce fuel rate by 10%
    elif engineCondition == 'High Pressure':
        fuelRateAdjustment = 0.1  # Increase fuel rate by 10%
    else:
        fuelRateAdjustment = 0  # No adjustment for normal or abnormal conditions

    return engineCondition, fuelRateAdjustment

# Simulate sensor data
time = np.arange(0, 1000, 0.1)  # Simulate for 1000 seconds at 0.1s intervals
temp = 600 + 400 * np.sin(0.1 * time)  # Example temperature data (600 to 1000 °C)
pressure = 200 + 200 * np.cos(0.1 * time)  # Example pressure data (200 to 400 kPa)
rpm = 20000 + 80000 * np.sin(0.2 * time)  # Example RPM data (20000 to 100000)

# Preallocate fuel flow array and engine condition array
fuelFlow = np.zeros_like(time)
engineConditions = np.zeros_like(time)  # To store numerical engine conditions

# Initial fuel rate
initialFuelRate = 1.0  # Assume initial fuel rate is 1.0 (arbitrary unit)

# Analyze conditions and adjust fuel rate
for i in range(len(time)):
    condition, adjustment = analyzeEngineCondition(temp[i], pressure[i], rpm[i])

    # Store the engine condition as a numerical value
    if condition == 'Normal':
        engineConditions[i] = 1
    elif condition == 'Overheating':
        engineConditions[i] = 2
    elif condition == 'Low Pressure':
        engineConditions[i] = 3
    elif condition == 'High Pressure':
        engineConditions[i] = 4
    elif condition == 'Abnormal':
        engineConditions[i] = 5

    if i == 0:
        fuelFlow[i] = max(0, initialFuelRate + adjustment)  # Initialize fuel flow
    else:
        fuelFlow[i] = max(0, fuelFlow[i - 1] + adjustment)  # Adjust fuel rate (ensure non-negative)

    # Debug prints (optional, can be commented out if not needed)
    print(f'Time: {time[i]:.1f} s, Temp: {temp[i]:.1f} °C, Pressure: {pressure[i]:.1f} kPa, RPM: {rpm[i]}, Condition: {condition}, Adjustment: {adjustment:.2f}, FuelFlow: {fuelFlow[i]:.2f}')

# Plot results
plt.figure(figsize=(10, 15))
plt.subplot(5, 1, 1)
plt.plot(time, temp)
plt.title('Temperature')
plt.ylabel('°C')

plt.subplot(5, 1, 2)
plt.plot(time, pressure)
plt.title('Pressure')
plt.ylabel('kPa')

plt.subplot(5, 1, 3)
plt.plot(time, rpm)
plt.title('RPM')
plt.ylabel('RPM')

plt.subplot(5, 1, 4)
plt.plot(time, fuelFlow)
plt.title('Fuel Flow')
plt.ylabel('Flow Rate')

plt.subplot(5, 1, 5)
plt.plot(time, engineConditions, 'o')
plt.title('Engine Conditions')
plt.ylabel('Condition')
plt.yticks([1, 2, 3, 4, 5], ['Normal', 'Overheating', 'Low Pressure', 'High Pressure', 'Abnormal'])
plt.xlabel('Time (s)')

plt.tight_layout()
plt.savefig('simulation_results.png')
plt.show()