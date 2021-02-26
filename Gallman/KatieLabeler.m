function out  = KatieLabeler(in)
% This function reads the original data collection files
% It filters the data and saves it into a single structure
% Performs these analyses: OBW, zAMP
% Relies on k_zAmp, k_FindMaxWindow, k_fft
%
% Usage: kg(#).info = KatieLabeler(kg(#).e)

    [~,out.folder,~]=fileparts(pwd);
    
    out.ld = input('Enter the LD schedule: ');
    startim = input('Enter the start time for the experiment: ');
    out.qual = input('Enter Quality of data (1-3): ');
    out.fishid = input('Enter fish name or identifier: ');
    out.feedingtimes = input('Enter feeding times in hours from start: ');
    
    
% LIGHT CYCLE ON/OFF STARTS        
    numbercycles = floor(in(1).s(end).timcont/(out.ld*60*60)); %number of cycles in data
    timz = 1:1:numbercycles;
    out.luz(timz) = startim + (out.ld*(timz-1)); %without for-loop

    meaninitialbright = mean([in(1).s([in(1).s.timcont] < out.luz(2)).light]);
    
    if meaninitialbright < 2.5 % Lights in initial period were off
        out.luz(1:2:end) = -out.luz(1:2:end); % Set initial period and every other subseqent  as off
    else
        out.luz(2:2:end) = -out.luz(2:2:end); % Set the second period and every other subsequent as off.
    end

    