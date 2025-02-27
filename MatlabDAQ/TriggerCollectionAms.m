%% Set up the DAQ

s = daq.createSession('ni');

% Add and configure Analogue Channels
    s.addAnalogInputChannel('Dev2', 0, 'voltage'); % EOD data
    s.addAnalogInputChannel('Dev2', 1, 'voltage'); % EOD data
%    s.addAnalogInputChannel('Dev2', 2, 'voltage'); % EOD data
    s.addAnalogInputChannel('Dev2', 3, 'voltage'); % Temp data
    s.addAnalogInputChannel('Dev2', 4, 'voltage'); % Light data

    s.Rate = 40000; %changed from 20000
    s.DurationInSeconds = 1; % 2 seconds seemed like too long
    s.NotifyWhenDataAvailableExceeds = s.Rate * s.DurationInSeconds;

% Add and configure Trigger    
    addTriggerConnection(s,'External','Dev2/PFI0','StartTrigger');
    %addTriggerConnection(s,'Digital', 'StartTrigger', 'Dev2/PFI0', 'External');
     
    s.Connections.TriggerCondition = 'FallingEdge';
    s.ExternalTriggerTimeout = 144000;
    s.TriggersPerRun = 1;
    
% Add separate light signal input
   %Create second device object
   l = daq.createSession('ni');
   
   %Add and configure Analogue channels
   l.addAnalogInputChannel('Dev2', 4, 'voltage'); % Light data
   
   %Add and confiture Trigger
    addTriggerConnection(l,'External','Dev2/PFI1','StartTrigger');
    
    l.Connections.TriggerCondition = 'FallingEdge';
    l.ExternalTriggerTimeout = 144000;
    l.TriggersPerRun = 1;
    
    
% Add the listener which can handle the data 
    lh = s.addlistener('DataAvailable', @listentothis);
    


pause(2);
%% Start collection


%[tmpData, tmpTime, tmpTriggerTimess] = s.startForeground();
numSamples = 0;

while numSamples < 10000
       
    fprintf('We are %i steps.\n', numSamples);
        l.startForeground(); 
        while l.IsWaitingForExternalTrigger
            pause(0.1);
        end
        s.startForeground();
    fprintf('We are are done waiting\n');
        pause(60) % After detection, pause for this long
        
        s.stop;
    
    numSamples = numSamples+1;

end



