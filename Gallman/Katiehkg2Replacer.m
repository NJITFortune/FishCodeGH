%function out = Katiehkg2Replacer(in)

% OBW        
%testing123
clearvars -except hkg2 hkg xxkg xxkg2 rkg2 k
in = hkg2(k);




    luz = [in.info.luz];
      
       
            for k = 2:4%length(luz)
            
            figure(1); clf;

                  kidx =  find([in.s.timcont]/3600 >= abs(luz(k-1))& [in.s.timcont]/3600 <abs(luz(k)));
                  
                  histogram([in.s(kidx).obwAmp],100);hold on;

                  %Lower lim
                    fprintf('Click cutoff for eliminating erroneously low amplitude measurements.\n');
                    [cutoffampL, ~]  = ginput(1);
                    plot([cutoffampL, cutoffampL], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
                    drawnow; 
                    
                  %Upper lim
                    fprintf('Click cutoff for eliminating erroneously high amplitude measurements.\n');
                    [cutoffampH, ~]  = ginput(1);
                    plot([cutoffampH, cutoffampH], [0 10], 'r-', 'LineWidth', 2, 'MarkerSize', 12);
                    drawnow; 
                    
                    obwidx{k-1, :} = find([in.s.obwAmp] > cutoffampL & [in.s.obwAmp] < cutoffampH);

                    
                 pause(1);
                
            end

            
        close(1);

             newobw(1,:) = in.s(obwidx{1}).obwAmp;

            for j = 2:3%length(luz)-1

                newobw = [newobw, in.s(obwidx{j}).obwAmp];
                
            end


           %   [~, out.obwidx, ~] = intersect([in.s.obwAmp], int32(newobw));





  

