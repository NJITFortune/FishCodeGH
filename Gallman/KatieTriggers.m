
%function [timcont, lighttimes, halfday] = KatieTriggers(in) 

%function [trial, day] = KatieDayDessembler(in, channel,  ReFs)
%% usage
%[trial, day] = KatieDayTrialDessembler(kg(#), channel, triallength, ReFs)
% 
% clear trial
% clear day
clearvars -except kg kg2 hkg hkg2 xxkg xxkg2
in = hkg(2);
channel = 1;
ReFs = 20;
close all;

%% Prepare data

%define lighttimes in seconds
ld = in.info.ld; % Whatever - ld is shorter than in.info.ld
%lighttimes = k_lighttimes(in, 3); 
luz = [in.info.luz];

%outlier removal
 tto = [in.idx(channel).obwidx]; 
      
%raw data
    timcont = [in.e(channel).s(tto).timcont]/3600; %time in hours
    obw = [in.e(channel).s(tto).obwAmp]/max([in.e(channel).s(tto).obwAmp]); %divide by max to normalize
    oldfreq = [in.e(channel).s(tto).fftFreq];
    oldtemp = [in.e(channel).s(tto).temp];
%% bins over time
% figure(34); clf; hold on;
% edges = lighttimes(1)/3600:ld/4:lighttimes(end)/3600;
%  h = histogram(timcont/3600, edges);   
% plot([lighttimes'/3600 lighttimes'/3600], ylim, 'r-');
%% Divide sample into days to compare against trial day means
figure(28); clf; hold on; 

ax(1) = subplot(211); title('trigger counts'); hold on;

    for k = 2:length(luz)
    
        if luz(k-1) < 0
            edges = abs(luz(k-1)):abs(luz(k));
          d = histogram(timcont, edges);
          d.Normalization = 'countdensity';
          d.FaceColor = [0.9 0.9 0.9];
        else
             edges = abs(luz(k-1)):abs(luz(k));
           l = histogram(timcont, edges); 
             l.Normalization = 'countdensity';
           l.FaceColor = 'y';
        end
    end
   
ax(2) = subplot(212); title('amplitude'); hold on;
    plot(timcont, obw, '.','MarkerSize', 8);

linkaxes(ax, 'x');
    
 %% plot to check

%plot all days of sample on top of eachother 










   