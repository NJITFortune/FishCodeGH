function out = KatieTempLabeler(in)
% Usage: kg(#).info = KatieTempLabeler(kg(#).e)

% clearvars -except kg
% in = kg(105).e;
%out = kg2(k).info

%% auto labels
%datafolder name
    %saved in Gallman
   % [~,out.folder,~]=fileparts(pwd);
     out.folder = input('Paste the folder info: ');
    
%light changes
    %output saved in vector luz
    %plots to check
        %plot light/time
      figure(58); clf; hold on;
        
        plot([in(1).s.timcont]/3600, [in(1).s.light]);
                    ylim([-1, 6]);
                    
        %find idicies where the light changes (threshold of 2.5)            
        ipt = findchangepts([in(1).s.light], 'MinThreshold', 2.5);
        
        
        if ~isempty(ipt)
            %create luz vector for light change times
                %lights on is +
                %lights off is -
            for j = 1:length(ipt)

                changepts(j) = [in(1).s(ipt(j)).timcont]/3600;
                if in(1).s(ipt(j)).light < 2.5
                    changepts(j) = -changepts(j);
                end

            end

            if changepts > 0
            plot([abs(changepts)' abs(changepts)'], [-1, 6], 'y-');
            else
            plot([abs(changepts)' abs(changepts)'], [-1, 6], 'k-');
            end

            out.luz = changepts;
        
        else
            
         out.luz = [];
            
        end
    
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
            out.temptims(j,:) = tempsort(j);
            plot([out.temptims(j), out.temptims(j)], ylim, 'b-');
        end
        end
%% manual labels
 %enter into command line
    out.ld = input('Enter the LD schedule: '); %temp code is 99 if constant light or dark
    out.fishid = input('Enter fish name or identifier: ');
    out.feedingtimes = input('Enter feeding times in hours from start: ');
    out.poweridx = input('Enter the values of timcont in hours over which to perform power analysis: ');
    

