function out = fmfilteredvelocity(in)
%% define variables
%non-function usage
% clearvars -except fm
% in = fm(1);


    medfiltnum = 11; 
    cutoffreq = 1;
    Fs = 15;
    %low pass filter
    [b,a] = butter(5, cutoffreq / (Fs/2), 'low');

%% Calculate filtered velocity

% Medfilt raw position data to remove bad tracking jumps  
    % (:,1) = x
    % (:,2) = y

  for j = length(in.s):-1:1
    
    in.s(j).nose(:,1) = medfilt1(in.s(j).nose(:,1), medfiltnum);
    in.s(j).nose(:,2) = medfilt1(in.s(j).nose(:,2), medfiltnum);
    in.s(j).fin(:,1) = medfilt1(in.s(j).fin(:,1), medfiltnum);
    in.s(j).fin(:,2) = medfilt1(in.s(j).fin(:,2), medfiltnum);
    in.s(j).tail(:,1) = medfilt1(in.s(j).tail(:,1), medfiltnum);
    in.s(j).tail(:,2) = medfilt1(in.s(j).tail(:,2), medfiltnum);
    

    % Calculate velocity from filtered posistion data
        for jj = length(in.s(1).nose)-1:-1:1
    
            ss(j).dNose(jj) = pdist2(in.s(j).nose(jj,1:2), in.s(j).nose(jj+1,1:2)); 
            ss(j).dFin(jj) = pdist2(in.s(j).fin(jj,1:2), in.s(j).fin(jj+1,1:2)); 
            ss(j).dTail(jj) = pdist2(in.s(j).tail(jj,1:2), in.s(j).tail(jj+1,1:2)); 
    
        end 
  
  end


for j = length(ss):-1:1 

        smean = filtfilt(b,a, medfilt1(ss(j).dNose, medfiltnum) );
        smean  = smean + filtfilt(b,a, medfilt1(ss(j).dFin,  medfiltnum) );
        smean = smean + filtfilt(b,a, medfilt1(ss(j).dTail, medfiltnum) );    
    
        ss(j).savg = smean / 3;
        ss(j).velmean = mean(ss(j).savg);
        ss(j).velstd = std(ss(j).savg);
end




%% average velocity

%average across tracking points

% for j = length(ss):-1:1 
% 
%     smean = zeros(1, length(ss(1).fNose));
%   
%   for t = 1:length(ss(1).fNose)
%     
%     smean = smean + ss(j).fNose(t);
%     smean = smean + ss(j).fFin(t);
% 
%     ss(j).smean(t,:) = smean + ss(j).fTail(t);
% 
%     ss(j).savg(t,:) = ss(j).smean(t)/3;
% 
%   end
% 
% end
%average per video

% for j = length(ss):-1:1 
% 
%         
%       ss(j).velmean = mean(ss(j).savg);
% 
% 
% 
% end
%% time

%create vector the length of the trial
% tt = 1:1:length(ss);
% 
% %multiply for videos taken every 10 minutes
% timcont = (tt-1) * 10;
% %convert to hours
% timcont = timcont / 60; 
% 
% %approximate lightchanges assuming we start at the cycle change
% numberoflightchanges = ceil(timcont(end)/12);
% lightz = 1:1:numberoflightchanges;
% 
% %lightlines = (4-(10/60)) + (lightz - 1) * 12;
% %lightlines = 5 + (lightz - 1) * 12;
% %lightlines = (10/60) + (lightz - 1) * 12;
% lightlines = (1+(20/60))+(lightz - 1) * 12;
%% save output to fm struct

out = ss;

%% plot

% figure(49); clf; hold on;
% 
%     plot(timcont, [ss.velmean], '.-');
%     plot([lightlines' lightlines'], ylim, 'k-');







