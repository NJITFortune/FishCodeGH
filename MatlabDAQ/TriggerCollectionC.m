%% Set up the DAQ

ss = daq.createSession('na');

% Add and configure Analogue Channels
    ss.addAnalogInputChannel('Dev2', 0, 'voltage'); % EOD data
    ss.addAnalogInputChannel('Dev2', 1, 'voltage'); % EOD data
%    s.addAnalogInputChannel('Dev2', 2, 'voltage'); % EOD data
    ss.addAnalogInputChannel('Dev2', 3, 'voltage'); % Temp data
    ss.addAnalogInputChannel('Dev2', 4, 'voltage'); % Light data

    ss.Rate = 40000; %Changed from 20000
    
    ss.DurationInSeconds = 1; % Started with 2, now 1 to try to reduce variability
    ss.NotifyWhenDataAvailableExceeds = ss.Rate * ss.DurationInSeconds;

% Add and configure Trigger    
    addTriggerConnection(ss,'External','Dev3/PFI0','StartTrigger');
    
    ss.Connections.TriggerCondition = 'FallingEdge';
    ss.ExternalTriggerTimeout = 144000;
    ss.TriggersPerRun = 1;
    
% Add the listener which can handle the data 
    lh = ss.addlistener('DataAvailable', @listentothisC);

pause(2);
%% Start collection

%[tmpData, tmpTime, tmpTriggerTimess] = s.startForeground();
numSamples = 0;

while numSamples < 100000
       
    fprintf('We are %i steps.\n', numSamples);
        ss.startForeground();
    fprintf('We are are done waiting\n');
        pause(60) % After detection, pause for this long
        
        ss.stop;
    
    numSamples = numSamples+1;

end



