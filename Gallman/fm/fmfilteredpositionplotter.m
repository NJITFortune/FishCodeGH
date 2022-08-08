function fmfilteredpositionplotter(in,j)
%% define variables
%non-function usage
% clearvars -except fm fmv
% in = fm(1);
% j = 1;

    medfiltnum = 11; 
    
  

        % Calculate velocity from filtered posistion data
        for jj = length(in.s(1).nose)-1:-1:1
    
            ss(j).doneNose(jj) = pdist2(in.s(j).onenose(jj,1:2), in.s(j).onenose(jj+1,1:2)); 
            ss(j).doneFin(jj) = pdist2(in.s(j).onefin(jj,1:2), in.s(j).onefin(jj+1,1:2)); 
            ss(j).doneTail(jj) = pdist2(in.s(j).onetail(jj,1:2), in.s(j).onetail(jj+1,1:2)); 
    
            ss(j).dtwoNose(jj) = pdist2(in.s(j).twonose(jj,1:2), in.s(j).twonose(jj+1,1:2)); 
            ss(j).dtwoFin(jj) = pdist2(in.s(j).twofin(jj,1:2), in.s(j).twofin(jj+1,1:2)); 
            ss(j).dtwoTail(jj) = pdist2(in.s(j).twotail(jj,1:2), in.s(j).twotail(jj+1,1:2)); 
        end 
 % end



%% Plot data
figure(1); clf; hold on; 
  
       %dorsal fin
        plot(in.s(j).onefin(:,1), -in.s(j).onefin(:,2), 'g.', 'MarkerSize', 8);
       %dorsal fin
        plot(in.s(j).twofin(:,1), -in.s(j).twofin(:,2), 'g.', 'MarkerSize', 8);

% Add dots for starting location
%     plot(in.s(j).nose(1,1), -in.s(j).nose(1,2), 'k.', 'MarkerSize', 16);
%     plot(in.s(j).fin(1,1), -in.s(j).fin(1,2), 'k.', 'MarkerSize', 16);
%     plot(in.s(j).tail(1,1), -in.s(j).tail(1,2), 'k.', 'MarkerSize', 16);
    box on;

% Calculate midline from nose position
%     xmax = max(in.s(j).nose(:,1));
%     xmin = min(in.s(j).nose(:,1));
   % xmid = (xmax - xmin)/2 +xmin;

    %plot([xmid, xmid], ylim, 'k-');
    

xlim([0 640]); ylim([-340 0]);



        
figure(2); clf; title('fish one velocity'); hold on
      
        plot(out.tim(2:end), medfilt1(dNose, medfiltnum), 'r');
        plot(out.tim(2:end), medfilt1(dFin, medfiltnum), 'g');
        plot(out.tim(2:end), medfilt1(dTail, medfiltnum),'b');     
        
        
legend('Nose', 'Dorsal Fin', 'Tail');

figure(2); clf; hold on

      
        plot(out.tim(2:end), medfilt1(dNose, medfiltnum), 'r');
        plot(out.tim(2:end), medfilt1(dFin, medfiltnum), 'g');
        plot(out.tim(2:end), medfilt1(dTail, medfiltnum),'b');     
        
        
        
legend('Nose', 'Dorsal Fin', 'Tail');