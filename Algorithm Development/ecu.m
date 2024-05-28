%Simulate Sensor Data
time = 0:0.1:100; %Siimulating 100 seconds at 0.1s interval
temp = 600 + 400*sin(0.1*time); %Temperature Data (600 to 1000 C)
pressure = 200 + 200*cos(0.1*time); %Pressure Data (200 to 400 kPa)
rpm = 20000 + 80000*sin(0.2*time); %RPM Data (20000 to 100000)

%Preallocate Fuel flow Array
fuelFlow = zeros(size(time));
engineConditions = strings(size(time)); %To store engine conditions

%Initial Fuel FLow rate
initialFuelrate = 1.0; %assumption

%Analyze conditions and adjust fuel flow rate
for i = 1:length(time)
    [~, adjustment] = analyzeEngineCondition(temp(i), pressure(i), rpm(i));
    if i == 1
        fuelFlow(i) = max(0, initialFuelrate + adjustment);
    else 
        fuelFlow(i) = max(0, fuelFlow(i-1) +adjustment);
    end
end

%Plot results
figure;
subplot(5,1,1);
plot(time, temp); title('Temperature');
subplot(5,1,2);
plot(time,pressure); title('Pressure');
subplot(5,1,3);
plot(time,rpm); title('RPM');
subplot(5,1,4);
subplot(time,fuelFlow); title('Fuel Flow');
subplot(5,1,5)
plot(time, engineConditions, 'o'); title('Engine Conditions');
ysticks(1:5);
ysticklabels({'Normal', 'Overheating', 'Low Pressure', 'High Pressure', 'Abnormal'});
xlabel('Time (s)');

%Function to analyze engine condition & adjust fuel flow rate
function [engineCondition, fuelRateadjustment] = analyzeEngineCondition(temp, pressure, rpm)
    %Define thresholds
    normalRange = [600,1000]; % Normal Condition
    overHeatingThreshold = 1000; 
    highPressureThreshold = 400;
    lowPressureThreshold = 200;

%Analyze Sensor Data & determine engine condition
if temp > overHeatingThreshold
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

%Determine fuel rate adjustment based on engine conditions
switch engineCondition
    case {'Overheating', 'Low Pressure'}
        fuelRateadjustment = -0.1; %Reduce fuel rate by 10%
    case {'High Pressure'}
        fuelRateadjustment = 0.1; %Increase fuel rate by 10%
    otherwise
        fuelRateadjustment = 0; %No adjustment
end
end
