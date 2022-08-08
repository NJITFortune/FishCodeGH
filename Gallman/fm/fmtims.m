function out = fmtims(in, lightstart)
%fmtims generates the time vector for the averaged velocity data based on
%when the fist video was taken (in ten minute intervals)
%lightstart = hour of the first light change
%  clearvars -except fm fmv dualfm dualfmv k
%  in = dualfmv(24);
%  k = 24;
%  howmanyfish = 2;
% lightstart = 16;
%% manually enter start time of experiment
%hour
 hourstart = input('Enter the hour the experiment started: ');
% %minute
 minutestart = input('Enter the minute the experiment started: ');
% %convert to minutes
% lightstart = 16
%hour
% hourstart = 16;
% % %minute
% minutestart =11;
%convert to minutes
starttim = (hourstart * 60) + minutestart;


%% create time vector

% timz = 1:1:length(in.ss);
% 
% timcont = starttim + (timz-1) *10;

 [gapidx] = fm_gapcheck(in.s);



% Construct the list of times for the videos we have
currtim = starttim;
for i = 1:length(in.s)
    % Is the current index in our list of missing videos?
    if ~isempty(find(gapidx == i, 1))
        % If so, we skipped, so add time for the missed video
        currtim = currtim + 10;
    end

    timcont(i) = currtim; % Set the time of the current video

    currtim = currtim + 10; % The next time for the next video
end



% timcont = timcont/60;%convert to hours

% for when we need to skip a video multi April13-UR
% timcont1 = timcont(1:96);
% timcont2 = timcont(97:510) + 10;
% timcont3 = timcont(511:end) + 20;
% 
% timcont = [timcont1 timcont2 timcont3];

% for when we need to skip a video multi April27-LR
% timcont1 = timcont(1:189);
% timcont2 = timcont(190:212) + 10;
% timcont3 = timcont(213:475) + 20;
% timcont4 = timcont(476:end) + 30;
% 
% timcont = [timcont1 timcont2 timcont3 timcont4];


% for when we need to skip a video in May23
% timcont1 = timcont(1:3);
% timcont2 = timcont(4:145) + 10;
% timcont3 = timcont(146:287) + 20;
% timcont4 = timcont(288:429) + 40;
% timcont5 = timcont(430:571) + 60;
% timcont6 = timcont(572:714) + 70;
% timcont7 = timcont(715:end) + 80;
% 
% timcont = [timcont1 timcont2 timcont3 timcont4 timcont5 timcont6 timcont7];


timcont = timcont/60;%convert to hours
% 
% 
% %computer midnight starts at 0 
% %% lightvector always happens at 4pm-4am
 lightz = 1:1:ceil(timcont(end)/12);
% %assume we always start in the afternoon b/c nothing good happens before 4
% %am
% %lightstart = 16 - (starttim/60);
% % if timcont(1) > lightstart
% %     lightstart = lightstart +12;
% % end
% 
lighttimes = lightstart + (lightz-1) * 12;
%create luz for light vs dark
for j = 1:length(lighttimes)
    if mod(j,2) == 1
        luz(j) = -lighttimes(j);
    else
        luz(j) = lighttimes(j);
    end
end
out.lighttimes = lighttimes;
out.timcont = timcont;
out.luz = luz;