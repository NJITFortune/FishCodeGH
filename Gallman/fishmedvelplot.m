function veldata = fishmedvelplot(out)
%USAGE
%v = fishmedvelplot(fm(1).s(27));
medfiltnum = 11; 
cutoffreq = 0.5;
Fs = 15;

%% Calculate shitty velocity

out.nose(:,1) = medfilt1(out.nose(:,1), medfiltnum);
out.nose(:,2) = medfilt1(out.nose(:,2), medfiltnum);
out.fin(:,1) = medfilt1(out.fin(:,1), medfiltnum);
out.fin(:,2) = medfilt1(out.fin(:,2), medfiltnum);
out.tail(:,1) = medfilt1(out.tail(:,1), medfiltnum);
out.tail(:,2) = medfilt1(out.tail(:,2), medfiltnum);

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
        
        %mNose(mNose > 15) = NaN;
        
        [b,a] = butter(5, cutoffreq / (Fs/2), 'low');

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
        ylim([0,40]);
       
figure(3); clf; hold on;
        plot(out.tim(2:end), fNose, 'r');
        plot(out.tim(2:end), fFin, 'g');
        plot(out.tim(2:end), fTail, 'b');

veldata(:,1) = fNose;
veldata(:,2) = fFin;
veldata(:,3) = fTail;

