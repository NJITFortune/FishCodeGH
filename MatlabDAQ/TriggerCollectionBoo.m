%% Set up the DAQ

s = daq.createSession("ni");

b = daqlist("ni")

deviceInfo = b{1, "DeviceInfo"}

bb = daq("ni");
bb.Rate = 40000;
addinput(bb, "Dev1", "ai0", "Voltage");
addinput(bb, "Dev1", "ai1", "Voltage");
addinput(bb, "Dev1", "ai2", "Voltage");
addinput(bb, "Dev1", "ai3", "Voltage");

tabledata = read(bb)

bbdata = read (bb, seconds(1));
plot(bbdata.Time, bbdata.Variables);
ylabel("Voltage (V)")
% % Add and configure Analogue Channels
%     s.addAnalogInputChannel('Dev2', 0, 'voltage'); % EOD data
%     s.addAnalogInputChannel('Dev2', 1, 'voltage'); % EOD data
% %    s.addAnalogInputChannel('Dev2', 2, 'voltage'); % EOD data
%     s.addAnalogInputChannel('Dev2', 3, 'voltage'); % Temp data
%     s.addAnalogInputChannel('Dev2', 4, 'voltage'); % Light data
% 
%     s.Rate = 40000; %changed from 20000
%     s.DurationInSeconds = 1; % 2 seconds seemed like too long
%     s.NotifyWhenDataAvailableExceeds = s.Rate * s.DurationInSeconds;
% 
% % Add and configure Trigger    
%     addTriggerConnection(s,'External','Dev2/PFI0','StartTrigger');
%     
%     s.Connections.TriggerCondition = 'FallingEdge';
%     s.ExternalTriggerTimeout = 144000;
%     s.TriggersPerRun = 1;
%     
% % Add the listener which can handle the data 
%     lh = s.addlistener('DataAvailable', @listentothis);
% 
% pause(2);
% %% Start collection
% 
% %[tmpData, tmpTime, tmpTriggerTimess] = s.startForeground();
% numSamples = 0;
% 
% while numSamples < 10000
%        
%     fprintf('We are %i steps.\n', numSamples);
%         s.startForeground();
%     fprintf('We are are done waiting\n');
%         pause(60) % After detection, pause for this long
%         
%         s.stop;
%     
%     numSamples = numSamples+1;
% 
% end



