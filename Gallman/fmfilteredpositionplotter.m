function fmfilteredpositionplotter(in,j)
%% define variables
%non-function usage
% clearvars -except fm fmv
% in = fm(1);
% j = 1;

    medfiltnum = 11; 
    
%% Calculate filtered velocity

% Medfilt raw position data to remove bad tracking jumps  
    % (:,1) = x
    % (:,2) = y

  %for j = 1%length(in.s):-1:1
    
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
 % end



%% Plot data
figure(1); clf; hold on;
  

       %nose
        plot(in.s(j).nose(:,1), -in.s(j).nose(:,2), '-b.', 'MarkerSize', 8);
       %dorsal fin
        plot(in.s(j).fin(:,1), -in.s(j).fin(:,2), '-g.', 'MarkerSize', 8);
       %tail
        plot(in.s(j).tail(:,1), -in.s(j).tail(:,2), '-r.', 'MarkerSize', 8);
       %legend
        legend('Nose', 'Dorsal Fin', 'Tail', 'AutoUpdate','off');

% Add dots for starting location
    plot(in.s(j).nose(1,1), -in.s(j).nose(1,2), 'k.', 'MarkerSize', 16);
    plot(in.s(j).fin(1,1), -in.s(j).fin(1,2), 'k.', 'MarkerSize', 16);
    plot(in.s(j).tail(1,1), -in.s(j).tail(1,2), 'k.', 'MarkerSize', 16);

% Calculate midline from nose position
    xmax = max(in.s(j).nose(:,1));
    xmin = min(in.s(j).nose(:,1));
    xmid = (xmax - xmin)/2 +xmin;

    plot([xmid, xmid], ylim, 'k-');
    

xlim([0 640]); ylim([-340 0]);



        
figure(2); clf; hold on

        plot(in.s(j).tim(2:end), ss(j).dNose, 'b');
        plot(in.s(j).tim(2:end), ss(j).dFin, 'g');
        plot(in.s(j).tim(2:end), ss(j).dTail,'r');     
%         plot(out.tim(2:end), medfilt1(dNose, 5), 'r');
%         plot(out.tim(2:end), medfilt1(dFin, 5), 'g');
%         plot(out.tim(2:end), medfilt1(dTail, 5),'b');     
        
legend('Nose', 'Dorsal Fin', 'Tail');