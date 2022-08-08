%function out = fishmongrel

Fs = 15;
confidencelevel = 0.95;
medfiltnum = 5; 
cutoffreq = 1; 
        
%% Load csvfile
[filer,pather] = uigetfile('*.csv');
%filer = 'PachonSFwormLD-Jan-21-2022_021-LLDLC_resnet50_SplitterJan25shuffle1_210000.csv';
%pather = 'C:\Users\DeepLabCut\Desktop\newFiles01-Jan21\LL\';

c = readmatrix(fullfile(pather,filer));


%% Put data into structure

out.filename = filer; 

out.tim = 1/Fs:1/Fs:length(c(:,1))/Fs;
out.Fs = Fs;

out.nose(:,1) = medfilt1(c(:,2), medfiltnum);
    %out.nose(:,1) = out.nose(:,1) - out.nose(1,1);
out.nose(:,2) = medfilt1(c(:,3), medfiltnum);
    %out.nose(:,2) = out.nose(:,2) - out.nose(1,2);
out.nose(:,3) = c(:,4);

%    x1 = diff(out.nose(:,1)); x2 = diff(out.nose(:,2));
%    x1f = filloutliers(x1, 'pchip'); x2f = filloutliers(x2, 'pchip');
%    x1fc = cumsum(x1f); x2fc = cumsum(x2f);
%    x1fc(end+1) = out.nose(end,1); x2fc(end+1) = out.nose(end,2);    
    
out.fin(:,1) = medfilt1(c(:,5), medfiltnum);
out.fin(:,2) = medfilt1(c(:,6), medfiltnum);
out.fin(:,3) = c(:,7);

out.tail(:,1) = medfilt1(c(:,8), medfiltnum);
out.tail(:,2) = medfilt1(c(:,9), medfiltnum);
out.tail(:,3) = c(:,10);

%% Calculate shitty velocity

for j=length(out.nose)-1:-1:1 
    dNose(j) = pdist2(out.nose(j,1:2), out.nose(j+1,1:2)); 
    dFin(j) = pdist2(out.fin(j,1:2), out.fin(j+1,1:2)); 
    dTail(j) = pdist2(out.tail(j,1:2), out.tail(j+1,1:2)); 
%    dNewNose(j) = pdist2([x1fc(j) x2fc(j)], [x1fc(j+1) x2fc(j+1)]);
end


%% Plot data
figure(1); clf; hold on;
        plot(out.nose(:,1), -out.nose(:,2), '-r.', 'MarkerSize', 8);
        plot(out.fin(:,1), -out.fin(:,2), '-g.', 'MarkerSize', 8);
        plot(out.tail(:,1), -out.tail(:,2), '-b.', 'MarkerSize', 8);
        legend('Nose', 'Dorsal Fin', 'Tail', 'AutoUpdate', 'off');

%        plot(x1fc, -x2fc, '-g.',  'MarkerSize', 8);

% figure(1); clf; hold on;
%     nn = find(out.nose(:,3) > confidencelevel);
%         plot(out.nose(nn,1), -out.nose(nn,2), '-r.', 'MarkerSize', 8);
%     ff = find(out.fin(:,3) > confidencelevel);
%         plot(out.fin(ff,1), -out.fin(ff,2), '-g.', 'MarkerSize', 8);
%     tt = find(out.tail(:,3) > confidencelevel);
%         plot(out.tail(tt,1), -out.tail(tt,2), '-b.', 'MarkerSize', 8);
%     legend('Nose', 'Dorsal Fin', 'Tail', 'AutoUpdate', 'off');

% Add dots for starting location
    plot(out.nose(1,1), -out.nose(1,2), 'k.', 'MarkerSize', 16);
    plot(out.fin(1,1), -out.fin(1,2), 'k.', 'MarkerSize', 16);
    plot(out.tail(1,1), -out.tail(1,2), 'k.', 'MarkerSize', 16);

xlim([0 640]); ylim([-340 0]);
        
figure(2); clf; 

%         plot(out.tim(2:end), medfilt1(dNose, 5), 'r');
%         plot(out.tim(2:end), medfilt1(dFin, 5), 'g');
%         plot(out.tim(2:end), medfilt1(dTail, 5),'b');     
        
%       legend('Nose', 'Dorsal Fin', 'Tail', 'AutoUpdate', 'off');

%    plot(out.tim(2:end), dNewNose, 'g');
       
        mNose = medfilt1(dNose, medfiltnum);
        mFin = medfilt1(dFin, medfiltnum);
        mTail = medfilt1(dTail, medfiltnum);

        [b,a] = butter(5, cutoffreq / (out.Fs/2), 'low');

        fNose = filtfilt(b,a,mNose);
        fFin = filtfilt(b,a,mFin);
        fTail = filtfilt(b,a,mTail);
        
ax(1) = subplot(311); hold on; plot(out.tim(2:end), dNose, 'r');
        plot(out.tim(2:end), mNose, 'c');
        plot(out.tim(2:end), fNose, 'k');

ax(2) = subplot(312); hold on; plot(out.tim(2:end), dFin, 'g');
        plot(out.tim(2:end), mFin, 'c');
        plot(out.tim(2:end), fFin, 'k');

ax(3) = subplot(313); hold on; plot(out.tim(2:end), dTail,'b');     
        plot(out.tim(2:end), mTail, 'c');
        plot(out.tim(2:end), fTail, 'k');
        
        linkaxes(ax, 'xy');
        
        
figure(3); clf; hold on;
        plot(out.tim(2:end), fNose, 'r');
        plot(out.tim(2:end), fFin, 'g');
        plot(out.tim(2:end), fTail, 'b');

