
%% Set up the DAQ
%s = electrical data input
s = daq.createSession('ni');

s.addAnalogInputChannel('Dev2', 0, 'voltage'); % EOD data
s.addAnalogInputChannel('Dev2', 1, 'voltage'); % EOD data
s.addAnalogInputChannel('Dev2', 2, 'voltage'); % EOD data
s.addAnalogInputChannel('Dev2', 3, 'voltage'); % Temp data
    s.Rate = 20000;
    s.DurationInSeconds = 5;
    s.NotifyWhenDataAvailableExceeds = s.Rate * s.DurationInSeconds;
%o = light control output
%o = daq.createSession('ni');
    %o.addAnalogOutputChannel('Dev1', 0, 'voltage'); % Regular light
    %o.addAnalogOutputChannel('Dev1', 1, 'voltage'); % IR light


%%
% White light plugs into AO0 (analogue output zero) and 
% IR light plugs into AO1 (analogue output one).
%LightONirOFF = timer;
%LightOFFirON = timer;
%LightONirOFF.TimerFcn = 'o.outputSingleScan([5, 0])';
%LightOFFirON.TimerFcn = 'o.outputSingleScan([0, 5])';


    %LightONirOFF.startat(2020,6,2,16,56,0); % When you want lights on
    %LightOFFirON.startat(2020,6,2,16,56,30); % when you want lights off


%%
lh = s.addlistener('DataAvailable', @listentothis);

%% Set up the camera
    %NET.addAssembly('C:\Program Files\Thorlabs\Scientific Imaging\DCx Camera Support\Develop\DotNet\uc480DotNet.dll');
    %5cam = uc480.Camera;
    %cam.Init(0);
    %cam.Display.Mode.Set(uc480.Defines.DisplayMode.DiB);
    %cam.PixelFormat.Set(uc480.Defines.ColorMode.RGBA8Packed);
    %cam.Trigger.Set(uc480.Defines.TriggerMode.Software);
    %[~, MemId] = cam.Memory.Allocate(true); 
    %[~, Width, Height, Bits, ~] = cam.Memory.Inquire(MemId); 
    %cam.Timing.Exposure.Set(8);

%% Loop to collect data

for j = 1:1
    
    % Start the DAQ in the background
    s.startBackground();
    fprintf('Collecting entry %2i out of 144.\n', j);
    % 60 seconds of collection
   % for k = 1:6
        %pause(5)
        % Acquire and process the photo data
       % cam.Acquisition.Freeze(uc480.Defines.DeviceParameter.Wait);
       % [~, tmp] = cam.Memory.CopyToArray(MemId);
       % vData = reshape(uint8(tmp), [Bits/8, Width, Height]);
       % vData = vData(1:3, 1:Width, 1:Height);
       % vData = permute(vData, [3,2,1]);
        % himg = imshow(vData); 
       % imageFileName = sprintf('GallmanImage_%s.mat', datestr(now, 'mm-dd-yyyy_HH-MM-SS'));
        %save(imageFileName, 'vData');        
        %pause(10);
    %end
  
    % Here is the pause between samples
    %pause(540);
    datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss')
    
end
