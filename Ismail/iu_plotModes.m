
evSmooth = curfish.error_vel(curfish.tracking == 3);
evActive = curfish.error_vel(curfish.tracking == 2);
evPoor = curfish.error_vel(curfish.tracking == 1);
evNon = curfish.error_vel(curfish.tracking == 0);


figure(27); clf;
    ax(1) = subplot(411); hold on; plot(curfish.shuttle_vel(curfish.tracking == 3)); plot(evSmooth, 'm.');
        xlim([0 length(evSmooth)])
    ax(3) = subplot(413); hold on; plot(curfish.shuttle_vel(curfish.tracking == 2)); plot(evActive, 'b.');
        xlim([2*length(evSmooth) 3*length(evSmooth)])
    ax(2) = subplot(412); hold on; plot(curfish.shuttle_vel(curfish.tracking == 1)); plot(evPoor, 'g.');
        xlim([0 length(evSmooth)])
    ax(4) = subplot(414); hold on; plot(curfish.shuttle_vel(curfish.tracking == 0)); plot(evNon, 'k.');
        xlim([2*length(evSmooth) 3*length(evSmooth)])

linkaxes(ax, 'y'); 

figure(28);

FevSmooth = fftmachine(evSmooth, curfish.fs);
FevActive = fftmachine(evActive, curfish.fs, 30);
FevPoor = fftmachine(evPoor, curfish.fs, 30);
FevNon = fftmachine(evNon, curfish.fs, 30);

subplot(221); plot(FevSmooth.fftfreq, FevSmooth.fftdata, 'm'); xlim([0 3]); title('Smooth');
subplot(222); plot(FevActive.fftfreq, FevActive.fftdata, 'b'); xlim([0 3]); title('Active');
subplot(223); plot(FevPoor.fftfreq, FevPoor.fftdata, 'g'); xlim([0 3]); title('Poor');
subplot(224); plot(FevNon.fftfreq, FevNon.fftdata, 'k'); xlim([0 3]); title('Non');


