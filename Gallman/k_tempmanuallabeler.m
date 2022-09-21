%function out = k_tempemanuallabeler(in)
%in = kg(#).e
%out = kg(k).info.luz

clearvars -except hkg k xxkg 
in = xxkg(k);

colddur = 5.6;
hotdur = 6.3;

timcont = [in.e(1).s.timcont]/3600;
temp = [in.e(1).s.temp];
temptims = [in.info.temptims];

figure(45); clf; hold on;
    plot(timcont, temp);
    plot([temptims temptims], ylim, 'k-');



 %startim = input('Enter the start time for the experiment: ');
 startim = 63.67;


    %caclulate hours when the light changed
        numbercycles = floor(timcont(end)/(mean([colddur, hotdur]))); %number of cycles in data
        timz = 1:1:numbercycles;

        templines(1) = startim;
        for j = 2:length(timz)
            
            if mod(j,2) == 0
                templines(j) = templines(j-1) + hotdur;
            else
                templines(j) = templines(j-1) + colddur;
            end

        end

    plot([templines, templines], ylim, 'r-');


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