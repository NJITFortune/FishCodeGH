
in = kg(51).e(1);

%temp changes
    %output saved in vector temptims
    %plots to check
        %plot temp/time
        figure(58); clf; hold on;
        plot([in.s.timcont]/3600, [in.s.temp]);
                    
                    
        %find idicies where the light changes (threshold of 2.5)  
            %autoplots but does not save. Use to check output
            %risetime([in.e(1).s.temp], [in.e(1).s.timcont]/3600);
            %falltime([in.e(1).s.temp], [in.e(1).s.timcont]/3600);
        
        %r = risetime
        %f = falltime
        %l= lowercross
        %u = uppercross
        [r, lrx, ~, ~, ~] = risetime([in.s.temp], [in.s.timcont]/3600);
        [f, ~, ufx, ~, ~] = falltime([in.s.temp], [in.s.timcont]/3600);
        
        
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
   