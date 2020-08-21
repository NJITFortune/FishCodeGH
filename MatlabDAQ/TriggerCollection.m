 %% Set up the DAQ

s = daq.createSession('ni');

% Add and configure Analogue Channels
s.addAnalogInputChannel('Dev2', 0, 'voltage'); % EOD data
s.addAnalogInputChannel('Dev2', 1, 'voltage'); % EOD data
s.addAnalogInputChannel('Dev2', 2, 'voltage'); % EOD data
s.addAnalogInputChannel('Dev2', 3, 'voltage'); % Temp data
    s.Rate = 20000;
    s.DurationInSeconds = 60;
    s.NotifyWhenDataAvailableExceeds = s.Rate * s.DurationInSeconds;

% Add and configure Trigger    
addTriggerConnection(s,'External','Dev2/PFI0','StartTrigger');
    s.Connections.TriggerCondition = 'FallingEdge';
    s.ExternalTriggerTimeout = 10;
    s.TriggersPerRun = 3;
    
% Add the listener which can handle the data 
lh = s.addlistener('DataAvailable', @listentothis);

% Collect data

[tmpData, tmpTime, tmpTriggerTimess] = s.startForeground();

