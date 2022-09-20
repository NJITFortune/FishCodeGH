%function temptims = k_templines(in)
% Usage: kg(#).info = KatieTempLabeler(kg(#).e)

clearvars -except xxkg hkg k
in = xxkg(k).e;
%out = kg2(k).info

 timcont = [in(1).s.timcont]/3600;
 temp = [in(1).s.temp];
%%
%temp changes
    %output saved in vector temptims
    %plots to check
        %plot temp/time
        figure(59); clf; hold on;
        plot([in(1).s.timcont]/3600, [in(1).s.temp]);
                    
                  
        %find idicies where the light changes (threshold of 2.5)  
            %autoplots but does not save. Use to check output
%             risetime([in(1).s.temp], [in(1).s.timcont]/3600);
%             falltime([in(1).s.temp], [in(1).s.timcont]/3600);
        
        %r = risetime
        %f = falltime
        %l= lowercross
        %u = uppercross
        [r, lrx, ~, ~, ~] = risetime([in(1).s.temp], [in(1).s.timcont]/3600);
        [f, ~, ufx, ~, ~] = falltime([in(1).s.temp], [in(1).s.timcont]/3600);
        
        if ~isempty(lrx) && ~isempty(ufx)
         
        %save rise indicis in center of temp change
            %lower cross plus risetime/2
        for j = 1:length(lrx)
            %plot([lrx(j)+(r(j)/2), lrx(j)+(r(j)/2)], ylim, 'k-');
            rise(j,:) = lrx(j)+(r(j)/2);
        %     plot([rise(j) rise(j)], ylim, 'b-');
        end
        
        
        %save fall indicis in center of temp change
            %upper cross plus falltime/2
        for k = 1:length(ufx)
            %plot([ufx(k)+(f(k)/2), ufx(k)+(f(k)/2)],  ylim, 'r-');
           fall(k,:) = ufx(k)+(f(k)/2);
        end
     
        %concatenate rise and fall times into single vector 
        alltemp = vertcat(rise, fall);
        %sort vector in ascending order
        [tempsort, ~] = sort(alltemp);
               
        %save vector as output
        %plot to check
        for j = 1:length(tempsort)
            temptims(j,:) = tempsort(j);
            plot([temptims(j), temptims(j)], ylim, 'b-');
        end
        end
%% manual labels
 %enter into command line
%     out.ld = input('Enter the LD schedule: '); %temp code is 99 if constant light or dark
%     out.fishid = input('Enter fish name or identifier: ');
%     out.feedingtimes = input('Enter feeding times in hours from start: ');
%     out.poweridx = input('Enter the values of timcont in hours over which to perform power analysis: ');
    

