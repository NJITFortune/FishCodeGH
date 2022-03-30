function out = fmfilteredmidxings(in)
%% define variables
%non-function usage
% clearvars -except fm fmv
% in = fm(1);


    medfiltnum = 11; 
%    cutoffreq = 1;
%     Fs = 15;
%     %low pass filter
%     [b,a] = butter(5, cutoffreq / (Fs/2), 'low');

%% Calculate filtered velocity

% Medfilt raw position data to remove bad tracking jumps  
    % (:,1) = x
    % (:,2) = y

  for j = 1%length(in.s):-1:1
    
    in.s(j).nose(:,1) = medfilt1(in.s(j).nose(:,1), medfiltnum);
    in.s(j).nose(:,2) = medfilt1(in.s(j).nose(:,2), medfiltnum);
%     in.s(j).fin(:,1) = medfilt1(in.s(j).fin(:,1), medfiltnum);
%     in.s(j).fin(:,2) = medfilt1(in.s(j).fin(:,2), medfiltnum);
%     in.s(j).tail(:,1) = medfilt1(in.s(j).tail(:,1), medfiltnum);
%     in.s(j).tail(:,2) = medfilt1(in.s(j).tail(:,2), medfiltnum);
%   
% 
%         % Calculate velocity from filtered posistion data
%         for jj = length(in.s(1).nose)-1:-1:1
%     
%             ss(j).dNose(jj) = pdist2(in.s(j).nose(jj,1:2), in.s(j).nose(jj+1,1:2)); 
%             ss(j).dFin(jj) = pdist2(in.s(j).fin(jj,1:2), in.s(j).fin(jj+1,1:2)); 
%             ss(j).dTail(jj) = pdist2(in.s(j).tail(jj,1:2), in.s(j).tail(jj+1,1:2)); 
%     
%         end 
  end



%% Plot data
% figure(1); clf; hold on;
%   
% 
%        %nose
%         plot(in.s(j).nose(:,1), -in.s(j).nose(:,2), '-b.', 'MarkerSize', 8);
%        %dorsal fin
%         plot(in.s(j).fin(:,1), -in.s(j).fin(:,2), '-g.', 'MarkerSize', 8);
%        %tail
%         plot(in.s(j).tail(:,1), -in.s(j).tail(:,2), '-r.', 'MarkerSize', 8);
%        %legend
%         legend('Nose', 'Dorsal Fin', 'Tail', 'AutoUpdate','off');
% 
% % Add dots for starting location
%     plot(in.s(j).nose(1,1), -in.s(j).nose(1,2), 'k.', 'MarkerSize', 16);
%     plot(in.s(j).fin(1,1), -in.s(j).fin(1,2), 'k.', 'MarkerSize', 16);
%     plot(in.s(j).tail(1,1), -in.s(j).tail(1,2), 'k.', 'MarkerSize', 16);
% 
% % Calculate midline from nose position
    xmax = max(in.s(j).nose(:,1));
    xmin = min(in.s(j).nose(:,1));
    xmid = (xmax - xmin)/2 +xmin;

   % plot([xmid, xmid], ylim, 'k-');
    

%xlim([0 640]); ylim([-340 0]);

%% midline xings

%adapted from k_zAmp.m for zero xings
    z = zeros(1,length(in.s(j).fin)); %create vector length of data
    z(in.s(j).nose(:,1) > xmid) = 1; %fill with 1s for all filtered data greater than xmid
    z = diff(z); %subtract the X(2) - X(1) to find the xings greater than the midline
    
    posZs = find(z == 1); 
    length(posZs)

    
    
%     amp = zeros(1,length(posZs)-1); % PreAllocate for speed
%     
%     for kk = 2:length(posZs)
%        %amp(kk-1) = max(in.s(j).nose((posZs(kk-1):posZs(kk)),1)) - (min(in.s(j).nose(posZs(kk-1):posZs(kk)),1)); % Max + min of signal for each cycle
%        amp(kk-1) = max(in.s(j).nose(posZs(kk-1):posZs(kk), 1)) - min(in.s(j).nose(posZs(kk-1):posZs(kk), 1));
%     end
%     
%     nosexings = mean(amp);

        
% figure(2); clf; hold on
% 
%         plot(in.s(j).tim(2:end), ss(j).dNose, 'b');
%         plot(in.s(j).tim(2:end), ss(j).dFin, 'g');
%         plot(in.s(j).tim(2:end), ss(j).dTail,'r');     
% %         plot(out.tim(2:end), medfilt1(dNose, 5), 'r');
% %         plot(out.tim(2:end), medfilt1(dFin, 5), 'g');
% %         plot(out.tim(2:end), medfilt1(dTail, 5),'b');     
%         
% legend('Nose', 'Dorsal Fin', 'Tail');