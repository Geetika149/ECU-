% Simulate sensor data
time = 0:0.1:1000;  % Simulate for 1000 seconds at 0.1s intervals
temp = 600 + 400*sin(0.1*time);  % Example temperature data (600 to 1000 °C)
pressure = 200 + 200*cos(0.1*time);  % Example pressure data (200 to 400 kPa)
rpm = 20000 + 80000*sin(0.2*time);  % Example RPM data (20000 to 100000)

% Preallocate fuel flow array and engine condition array
fuelFlow = zeros(size(time));
engineConditions = zeros(size(time));  % To store numerical engine conditions

% Initial fuel rate
initialFuelRate = 1.0;  % Assume initial fuel rate is 1.0 (arbitrary unit)

% Analyze conditions and adjust fuel rate
for i = 1:length(time)
    [condition, adjustment] = analyzeEngineCondition(temp(i), pressure(i), rpm(i));
    
    % Store the engine condition as a numerical value
    switch condition
        case 'Normal'
            engineConditions(i) = 1;
        case 'Overheating'
            engineConditions(i) = 2;
        case 'Low Pressure'
            engineConditions(i) = 3;
        case 'High Pressure'
            engineConditions(i) = 4;
        case 'Abnormal'
            engineConditions(i) = 5;
    end
    
    if i == 1
        fuelFlow(i) = max(0, initialFuelRate + adjustment);  % Initialize fuel flow
    else
        fuelFlow(i) = max(0, fuelFlow(i-1) + adjustment);  % Adjust fuel rate (ensure non-negative)
    end
    
    % Debug prints (optional, can be commented out if not needed)
    fprintf('Time: %.1f s, Temp: %.1f °C, Pressure: %.1f kPa, RPM: %.0f, Condition: %s, Adjustment: %.2f, FuelFlow: %.2f\n', ...
        time(i), temp(i), pressure(i), rpm(i), condition, adjustment, fuelFlow(i));
end

% Plot results
figure;
subplot(5,1,1);
plot(time, temp); title('Temperature'); ylabel('°C');
subplot(5,1,2);
plot(time, pressure); title('Pressure'); ylabel('kPa');
subplot(5,1,3);
plot(time, rpm); title('RPM'); ylabel('RPM');
subplot(5,1,4);
plot(time, fuelFlow); title('Fuel Flow'); ylabel('Flow Rate');
subplot(5,1,5);
plot(time, engineConditions, 'o'); title('Engine Conditions'); ylabel('Condition');
yticks(1:5);
yticklabels({'Normal', 'Overheating', 'Low Pressure', 'High Pressure', 'Abnormal'});
xlabel('Time (s)');

% Function to analyze engine condition and adjust fuel rate
function [engineCondition, fuelRateAdjustment] = analyzeEngineCondition(temp, pressure, rpm)
    % Define thresholds
    normalRange = [600, 1000];  % Temperature range for normal condition
    overheatingThreshold = 1000;  % Overheating temperature threshold
    highPressureThreshold = 400;  % High pressure threshold
    lowPressureThreshold = 200;  % Low pressure threshold

    % Analyze sensor data and determine engine condition
    if temp > overheatingThreshold
        engineCondition = 'Overheating';
    elseif pressure < lowPressureThreshold
        engineCondition = 'Low Pressure';
    elseif pressure > highPressureThreshold
        engineCondition = 'High Pressure';
    elseif temp < normalRange(1) || temp > normalRange(2) || rpm < 20000 || rpm > 100000
        engineCondition = 'Abnormal';
    else
        engineCondition = 'Normal';
    end

    % Determine fuel rate adjustment based on engine condition
    switch engineCondition
        case 'Overheating'
            fuelRateAdjustment = -0.1;  % Reduce fuel rate by 10%
        case 'Low Pressure'
            fuelRateAdjustment = -0.1;  % Reduce fuel rate by 10%
        case 'High Pressure'
            fuelRateAdjustment = 0.1;  % Increase fuel rate by 10%
        case 'Normal'
            fuelRateAdjustment = 0;  % No adjustment for normal condition
        otherwise
            fuelRateAdjustment = 0;  % No adjustment for abnormal conditions
    end
end
