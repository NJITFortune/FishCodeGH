function out = KatieMultiLabeler(in)

% Usage: kg(#).info = KatieTempLabeler(kg(#).s)
%in = kg2(k).s
%out = kg2(k).info


%kg2(k).s.temp
%% auto labels
%datafolder name
    %saved in Gallman
    [~,out.folder,~]=fileparts(pwd);
    
%light changes
    %output saved in vector luz
    %plots to check
        %plot light/time
        figure(58); clf; hold on;
        
        plot([in.s.timcont]/3600, [in.s.light]);
                    ylim([-1, 6]);
                    
        %find idicies where the light changes (threshold of 2.5)            
        ipt = findchangepts([in.s.light], 'MinThreshold', 2.5);
        
        %create luz vector for light change times
            %lights on is +
            %lights off is -
        for j = 1:length(ipt)
            
            changepts(j) = [in.s(ipt(j)).timcont]/3600;
            if in.s(ipt(j)).light < 2.5
                changepts(j) = -changepts(j);
            end
            
        end
            
        if changepts > 0
        plot([abs(changepts)' abs(changepts)'], [-1, 6], 'y-');
        else
        plot([abs(changepts)' abs(changepts)'], [-1, 6], 'k-');
        end
        
        out.luz = changepts;

%temp changes
    %output saved in vector temptims
    %plots to check
        %plot temp/time
%         figure(58); clf; hold on;
%         plot([in.s.timcont]/3600, [in.s.temp]);
% 
%                     
%     %click new figure bounds starting from left
%     [x, ~] = ginput(2);
%     
%     
%     tt = find([in.s.timcont]/(60*60) > x(1) & [in.s.timcont]/(60*60) < x(2));
%             out.s = in.s(tt);
%    
%                     
%         %find idicies where the light changes (threshold of 2.5)  
%             %autoplots but does not save. Use to check output
%             %risetime([in.e(1).s.temp], [in.e(1).s.timcont]/3600);
%             %falltime([in.e(1).s.temp], [in.e(1).s.timcont]/3600);
%         
%         %r = risetime
%         %f = falltime
%         %l= lowercross
%         %u = uppercross
%         [r, lrx, ~, ~, ~] = risetime([in.s(tt).temp], [in.s(tt).timcont]/3600);
%         [f, ~, ufx, ~, ~] = falltime([in.s(tt).temp], [in.s(tt).timcont]/3600);
%         
%         
%         %save rise indicis in center of temp change
%             %lower cross plus risetime/2
%         for j = 1:length(lrx)
%             %plot([lrx(j)+(r(j)/2), lrx(j)+(r(j)/2)], ylim, 'k-');
%             rise(j,:) = lrx(j)+(r(j)/2);
%         %     plot([rise(j) rise(j)], ylim, 'b-');
%         end
%         
%         
%         %save fall indicis in center of temp change
%             %upper cross plus falltime/2
%         for k = 1:length(ufx)
%             %plot([ufx(k)+(f(k)/2), ufx(k)+(f(k)/2)],  ylim, 'r-');
%            fall(k,:) = ufx(k)+(f(k)/2);
%         end
%      
%         %concatenate rise and fall times into single vector 
%         alltemp = vertcat(rise, fall);
%         %sort vector in ascending order
%         [tempsort, ~] = sort(alltemp);
%                
%         %save vector as output
%         %plot to check
%         for j = 1:length(tempsort)
%             out.temptims(j,:) = tempsort(j);
%             plot([out.temptims(j), out.temptims(j)], ylim, 'b-');
%         end
   
%% manual labels
 %enter into command line
    out.ld = input('Enter the LD schedule: '); %temp code is 99 if constant light or dark
    out.fishid = input('Enter fish name or identifier: ');
    out.feedingtimes = input('Enter feeding times in hours from start: ');
    out.Hipoweridx = input('Enter the values of timcont in hours over which to perform power analysis on the high frequency fish: ');
    out.Lopoweridx = input('Enter the values of timcont in hours over which to perform power analysis on the low frequency fish: ');
    


