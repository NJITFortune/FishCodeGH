%% Set up the DAQ

s = daq.createSession('ni');

% Add and configure Analogue Channels
    s.addAnalogInputChannel('Dev2', 0, 'voltage'); % EOD data
    s.addAnalogInputChannel('Dev2', 1, 'voltage'); % EOD data
    s.addAnalogInputChannel('Dev2', 2, 'voltage'); % EOD data
    s.addAnalogInputChannel('Dev2', 3, 'voltage'); % Temp data
    s.addAnalogInputChannel('Dev2', 4, 'voltage'); % Light data

    s.Rate = 20000;
    s.DurationInSeconds = 2;
    s.NotifyWhenDataAvailableExceeds = s.Rate * s.DurationInSeconds;

% Add and configure Trigger    
    addTriggerConnection(s,'External','Dev2/PFI0','StartTrigger');
    
    s.Connections.TriggerCondition = 'FallingEdge';
    s.ExternalTriggerTimeout = 144000;
    s.TriggersPerRun = 1;
    
% Add the listener which can handle the data 
    lh = s.addlistener('DataAvailable', @listentothis);

pause(2);
%% Start collection

%[tmpData, tmpTime, tmpTriggerTimess] = s.startForeground();
numSamples = 0;

while numSamples < 10000
       
    fprintf('We are %i steps.\n', numSamples);
    s.startBackground();
    pause(1); % Give DAQ some time to breath

    while s.IsDone == 1
        fprintf('We are are done waiting\n');
        pause(10) % After detection, pause for this long
    end
    
    numSamples = numSamples+1;

end

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


