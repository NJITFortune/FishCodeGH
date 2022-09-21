%function out = k_tempemanuallabeler(in)
%in = kg(#).e
%out = kg(k).info.luz

clearvars -except hkg k xxkg 
in = xxkg(k);



timcont = [in.e(1).s.timcont]/3600;
temp = [in.e(1).s.temp];
temptims = [in.info.temptims];

figure(45); clf; hold on;
    plot(timcont, temp);
    plot([temptims temptims], ylim, 'k-');

%separate rise from fall    
for j = 2:length(temptims)
    
    tempidx = find(timcont >= temptims(j-1) & timcont < temptims(j));

    if mean(temp(tempidx)) > mean(temp)
        tiz(j-1,:) = temptims(j-1);
    else
        tiz(j-1,:) = -temptims(j-1);
    end

end    

% tempdif = diff(temptims);
% tidx = find(tempdif > 7);
% 
% for j = 1:length(tidx)
% 
%     lineidx = find(temptims == temptims(tidx(j)));
% 
%     if tiz(tidx(j)) < 0
%         temptims = [temptims(1:lineidx -1), ]
% 
% end
% 
%     plot([temptims(tidx(2)), temptims(tidx(2))], ylim, 'r-');
%     yline(mean(temp));
%     
% 
% 
% temptims = [temptims(1:lineidx -1) temptims(tidx(2)) ]

% 
%     figure(32); clf; hold on;
%          risetime(temp, timcont);
% 
%     figure(33); clf; hold on;
%        falltime(temp, timcont);
% 



% colddur = 5.6;
% hotdur = 6.3;

%  %startim = input('Enter the start time for the experiment: ');
  startim = temptims(1);
% 

    %caclulate hours when the light changed
        numbercycles = floor(timcont(end)/6; %number of cycles in data
        timz = 1:1:numbercycles;
        testtims(timz) = startim + (6*(timz-1)); %without for-loop

plot([testtims, testtims], ylim, 'r-', 'LineWidth', 2);

%         templines(1) = startim;
%         for j = 2:length(timz)
%             
%             if mod(j,2) == 0
%                 templines(j) = templines(j-1) + hotdur;
%             else
%                 templines(j) = templines(j-1) + colddur;
%             end
% 
%         end
% 
%     plot([templines', templines'], ylim, 'r-');


% 
%         out(timz) = startim + (in.info.ld*(timz-1)); %without for-loop
%         
%          %find the time indicies for the first light cycle
%         lidx = [in.e(1).s.timcont] < out(2)*(60*60);  
%     %take the mean of the light values in the first cycle
%         meaninitialbright = mean([in.e(1).s(lidx).light]);
%     
%     %Assign negative values to luz when lights were off
%         if meaninitialbright < 2.5 % Lights in initial period were off
%             out(1:2:end) = -out(1:2:end); % Set initial period and every other subseqent  as off
%         else
%             out(2:2:end) = -out(2:2:end); % Set the second period and every other subsequent as off.
%         end