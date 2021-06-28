%% Set up the DAQ

s = daq.createSession('ni');

% Add and configure Analogue Channels
    s.addAnalogInputChannel('Dev3', 0, 'voltage'); % EOD data
    s.addAnalogInputChannel('Dev3', 1, 'voltage'); % EOD data
    %s.addAnalogInputChannel('Dev2', 2, 'voltage'); % EOD data
    s.addAnalogInputChannel('Dev3', 3, 'voltage'); % Temp data
    s.addAnalogInputChannel('Dev3', 4, 'voltage'); % Light data

    s.Rate = 40000; %changed from 20000
   
    s.DurationInSeconds = 1; % Started with 2, now 1 to try to reduce variability
    s.NotifyWhenDataAvailableExceeds = s.Rate * s.DurationInSeconds;

% Add and configure Trigger    
    addTriggerConnection(s,'External','Dev3/PFI0','StartTrigger');
    addTriggerConnection(s,'External','Dev3/PFI1','StartTrigger');
    
    s.Connections.TriggerCondition = 'FallingEdge';
    s.ExternalTriggerTimeout = 144000;
    s.TriggersPerRun = 1;
    
% Add the listener which can handle the data 
    lh = s.addlistener('DataAvailable', @listentothisB);

pause(2);
%% Start collection

%[tmpData, tmpTime, tmpTriggerTimess] = s.startForeground();
numSamples = 0;

while numSamples < 100000
       
    fprintf('We are %i steps.\n', numSamples);
        s.startForeground();
    fprintf('We are are done waiting\n');
        pause(60) % After detection, pause for this long
        
        s.stop;
    
    numSamples = numSamples+1;

end



