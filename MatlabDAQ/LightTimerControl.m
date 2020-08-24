s = daq.createSession('ni');
    
% Set up the Analogue outputs

    s.addAnalogOutputChannel('Dev2', 0, 'voltage'); % Regular light
    s.addAnalogOutputChannel('Dev2', 1, 'voltage'); % IR light


% White light plugs into AO0 (analogue output zero) and 
% IR light plugs into AO1 (analogue output one).

% Initiate the timer objects
    A_LightONirOFF = timer;
    B_LightOFFirON = timer;
    C_LightONirOFF = timer;
    D_LightOFFirON = timer;

% Tell the timer objects what to do    
    A_LightONirOFF.TimerFcn = 's.outputSingleScan([5, 0])';
    B_LightOFFirON.TimerFcn = 's.outputSingleScan([0, 5])';
    C_LightONirOFF.TimerFcn = 's.outputSingleScan([5, 0])';
    D_LightOFFirON.TimerFcn = 's.outputSingleScan([0, 5])';

% Tell the timer objects when to do it.     
     A_LightONirOFF.startat(2020,8,24,12,16,0); % When you want lights on
     B_LightOFFirON.startat(2020,8,24,12,16,15); % when you want lights off
     C_LightONirOFF.startat(2020,8,24,12,16,30); % When you want lights on
     D_LightOFFirON.startat(2020,8,24,12,16,45); % when you want lights off

