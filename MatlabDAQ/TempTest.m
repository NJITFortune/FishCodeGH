%% Set up the DAQ

s = daq.createSession('ni');

% Add and configure Analogue Channels
%     s.addAnalogInputChannel('Dev3', 0, 'voltage'); % EOD data
%     s.addAnalogInputChannel('Dev3', 1, 'voltage'); % EOD data
    %s.addAnalogInputChannel('Dev2', 2, 'voltage'); % EOD data
    s.addAnalogInputChannel('Dev3', 3, 'voltage'); % Temp data
    s.addAnalogInputChannel('Dev3', 4, 'voltage'); % Light data

    s.Rate = 40000; %changed from 20000
   
    s.DurationInSeconds = 1; % Started with 2, now 1 to try to reduce variability
    s.NotifyWhenDataAvailableExceeds = s.Rate * s.DurationInSeconds;
    
% Add the listener which can handle the data 
    lh = s.addlistener('DataAvailable', @listentothisB);

pause(2);
%% Start collection

%% Loop to collect data

for j = 1:144
    
    % Start the DAQ in the background
    s.startBackground();
    fprintf('Collecting entry %2i out of 144.\n', j);
    % 60 seconds of collection
    for k = 1:6
%         pause(5)
%         % Acquire and process the photo data
%         cam.Acquisition.Freeze(uc480.Defines.DeviceParameter.Wait);
%         [~, tmp] = cam.Memory.CopyToArray(MemId);
%         vData = reshape(uint8(tmp), [Bits/8, Width, Height]);
%         vData = vData(1:3, 1:Width, 1:Height);
%         vData = permute(vData, [3,2,1]);
%         % himg = imshow(vData); 
%         imageFileName = sprintf('GallmanImage_%s.mat', datestr(now, 'mm-dd-yyyy_HH-MM-SS'));
%         save(imageFileName, 'vData');        
        pause(10);
    end

    % Here is the pause between samples
    pause(540);
    datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss')
    
end
