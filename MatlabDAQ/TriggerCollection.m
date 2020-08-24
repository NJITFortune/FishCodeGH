%% Set up the DAQ

s = daq.createSession('ni');

% Add and configure Analogue Channels
s.addAnalogInputChannel('Dev2', 0, 'voltage'); % EOD data
s.addAnalogInputChannel('Dev2', 1, 'voltage'); % EOD data
s.addAnalogInputChannel('Dev2', 2, 'voltage'); % EOD data
s.addAnalogInputChannel('Dev2', 3, 'voltage'); % Temp data
    s.Rate = 20000;
    s.DurationInSeconds = 1;
    s.NotifyWhenDataAvailableExceeds = s.Rate * s.DurationInSeconds;

% Add and configure Trigger    
addTriggerConnection(s,'External','Dev2/PFI0','StartTrigger');
    s.Connections.TriggerCondition = 'FallingEdge';
    s.ExternalTriggerTimeout = 600;
    s.TriggersPerRun = 3;
    
% Add the listener which can handle the data 
lh = s.addlistener('DataAvailable', @listentothis);

% Set up the light control

    s.addAnalogOutputChannel('Dev2', 0, 'voltage'); % Regular light
    s.addAnalogOutputChannel('Dev2', 1, 'voltage'); % IR light

    s.outputSingleScan([0, 5])
%
% White light plugs into AO0 (analogue output zero) and 
% IR light plugs into AO1 (analogue output one).
%     A_LightONirOFF = timer;
%     B_LightOFFirON = timer;
%     C_LightONirOFF = timer;
%     D_LightOFFirON = timer;

%     A_LightONirOFF.TimerFcn = 's.outputSingleScan([5, 0])';
%     B_LightOFFirON.TimerFcn = 's.outputSingleScan([0, 5])';
%     C_LightONirOFF.TimerFcn = 's.outputSingleScan([5, 0])';
%     D_LightOFFirON.TimerFcn = 's.outputSingleScan([0, 5])';

    
% Collect data

[tmpData, tmpTime, tmpTriggerTimess] = s.startForeground();

    
%     
%     LightONirOFF.startat(2020,8,24,11,56,0); % When you want lights on
%     LightOFFirON.startat(2020,8,24,11,56,30); % when you want lights off


