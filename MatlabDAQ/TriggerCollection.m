%% Set up the DAQ

s = daq.createSession('ni');

% Add and configure Analogue Channels
s.addAnalogInputChannel('Dev2', 0, 'voltage'); % EOD data
s.addAnalogInputChannel('Dev2', 1, 'voltage'); % EOD data
s.addAnalogInputChannel('Dev2', 2, 'voltage'); % EOD data
s.addAnalogInputChannel('Dev2', 3, 'voltage'); % Temp data
s.addAnalogInputChannel('Dev2', 4, 'voltage'); % Light data

    s.Rate = 20000;
    s.DurationInSeconds = 1;
    s.NotifyWhenDataAvailableExceeds = s.Rate * s.DurationInSeconds;

% Add and configure Trigger    
addTriggerConnection(s,'External','Dev2/PFI0','StartTrigger');
    s.Connections.TriggerCondition = 'FallingEdge';
    s.ExternalTriggerTimeout = 144000;
    s.TriggersPerRun = 1000;
    
% Add the listener which can handle the data 
lh = s.addlistener('DataAvailable', @listentothis);


%% Start collection

%[tmpData, tmpTime, tmpTriggerTimess] = s.startForeground();
s.startBackground();


%% Test loop
%     a = 0;
% 
%     while a < 20
%         
%     fprintf('Collection is possible.\n');
%     s.startForeground();
%     fprintf('PAUSED.\n');
%     pause(20);
%     a = a+1;
%     fprintf('Entry %i. \n', a);
%     
%     end


