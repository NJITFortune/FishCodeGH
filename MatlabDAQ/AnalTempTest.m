function out = KgallmAnalysis(userfilespec, Fs, numstart)
% Function out = gallmAnalysis(userfilespec, Fs)
% userfilespec is data from listentothis.m, e.g. 'EigenTest*.mat'
% Fs is the sample rate, was 20kHz but now 40kHz
% numstart is the first character of the hour. 

%% Setup

rango = 10; % Hz around peak frequency over which to sum amplitude.

%dataChans = [1 2];
tempchan = 3;
lightchan = 4;    

%Variables for voltage to temp calculation
     R1b = 9500;

     c1 = 1.009249522e-03;
     c2 = 2.378405444e-04; 
     c3 = 2.019202697e-07;
    
    

    
iFiles = dir(userfilespec);

daycount = 0;

%% Cycle through every file in the directory

k = 1; % Our counter.

while k <= length(iFiles)

    eval(['load ' iFiles(k).name]);

   
    % Get EOD amplitudes for each channel
    for j = length(tempchan):-1:1
    
         
          R2b = R1b * ((1023.0 /tempchan(j)) - 1.0);
          logR2b = log(R2b);
          Tb = (1.0 / (c1 + c2*logR2b + c3*logR2b*logR2b*logR2b));
          Tb = Tb - 273.15;
    
    end     
        
    out(k).light = mean(data(:,lightchan));
    out(k).temp = mean(Tb);
    
% Add time stamps (in seconds) relative to computer midnight
 
    hour = str2num(iFiles(k).name(numstart:numstart+1)); %numstart based on time stamp text location
    minute = str2num(iFiles(k).name(numstart+3:numstart+4));
    second = str2num(iFiles(k).name(numstart+6:numstart+7));

    if k > 1 && ((hour*60*60) + (minute*60) + second) < out(k-1).tim24
        daycount = daycount + 1;
    end
        % There are 86400 seconds in a day.
    out(k).timcont = (hour*60*60) + (minute*60) + second + (daycount*86400) ;
    out(k).tim24 = (hour*60*60) + (minute*60) + second;
    
    k = k+1;
    

end

% %% Create a separate vector for exact light time changes
%  
% %Get the name of the current folder
% %[~,folder,~]=fileparts(pwd);
% %extract the light cycle info and convert to number
% %timstep = str2num(folder(6:7)); %length of light cycle in hours
% timstep = 24;
% cyc = floor([out(end).timcont]/(timstep*60*60)); %number of cycles in data
% 
% %user defined details by light trial
% timerstart = 17; %hour of the first state change
% %initstate = 0; %initial state
% 
% %timz = 1:1:cyc; %to avoid for-loop
% 
% ztzed = [0 6]; %y
% 
% 
% %luz(timz) = (timerstart) + (timstep*(timz-1)); %without for-loop
% 
% for i = 1:cyc
%     luz(i)=timstep*(i-1)+timerstart;
%     x1(:,i) = [luz(i), luz(i)];
%     
%     out(i).luz = x1(:,i);
% end    


%% Plot the data for fun

% Continuous data plot
figure(1); clf; 
    set(gcf, 'Position', [200 100 2*560 2*420]);


ax(1) = subplot(211); hold on;
    plot([out.timcont]/(60*60), [out.temp], '.');
   
ax(2) = subplot(212); hold on;
    plot([out.timcont]/(60*60), [out.light], '.', 'Markersize', 8);
    %plot([out.luz], ztzed, '.-', 'Markersize', 8);
    ylim([-1, 6]);
    xlabel('Continuous');

linkaxes(ax, 'x');
    
