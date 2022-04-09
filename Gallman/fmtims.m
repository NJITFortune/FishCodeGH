function out = fmtims(in)

% clearvars -except fm
% in = fm(1);
%% manually enter start time of experiment
%hour
hourstart = input('Enter the hour the experiment started: ');
%minute
minutestart = input('Enter the minute the experiment started: ');
%convert to minutes
starttim = (hourstart * 60) + minutestart;
%% create time vector
timz = 1:1:length(in.ss);
timcont = starttim + (timz-1) *10;
timcont = timcont/60;%convert to hours



%computer midnight starts at 0 
%% lightvector always happens at 4pm-4am
lightz = 1:1:ceil(timcont(end)/12);
%assume we always start in the afternoon b/c nothing good happens before 4
%am
%lightstart = 16 - (starttim/60);
out.lighttimes = 16 + (lightz-1) * 12;
out.timcont = timcont;