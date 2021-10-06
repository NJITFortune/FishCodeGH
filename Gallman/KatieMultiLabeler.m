function out = KatieMultiLabeler(in)
% This function reads the original data collection files
% It filters the data and saves it into a single structure
% Performs these analyses: OBW, zAMP
% Relies on k_zAmp, k_FindMaxWindow, k_fft
%
% Usage: kg(#).info = KatieLabeler(kg(#).e)

   [~,out.folder,~]=fileparts(pwd);
    
    
    startim = input('Enter the start time for the experiment: ');
    
    out.fishid = input('Enter fish name or identifier: ');
    out.feedingtimes = input('Enter feeding times in hours from start: ');
   
    out.poweridx = input('Enter the values of timcont in hours over which to perform power analysis: ');
    
       
