function [evOUT, faOUT] = iu_getAllstas(curfish, fishNo) 

% load finalIsmaildata2024.mat

windowwidth = 2;
fewestNumberofSpikes = 2000;

for ff = fishNo
% 1 3 5 -8 -10 
% New Ismail structure
% >>>>>>>> 1 andre_2019_04_10 NOTHING
% 2 ankara_2019_01_31 Weak EV on 8(?) just one unit
% 3 bammbamm_2019_04_12 EXCELLENT EA to FA (EV centered on zero)
% 4 bent_2019_02_26 EXCELLENT - EV to FA (not as nice as 9)
% >>>>>>>> 5 brown_2018_09_25 NOTHING
% 6 brownie_p1_2019_01_26 Maybe EA?
% 7 brownie_p2_2019_01_26 Maybe weak FV?
% 8 bumpy_2019_04_03 INTERESTING Error Accel and more?
% 9 fin_2019_04_14 THE BEST - EV to FA
% >>>>>>>> 10 goldy_2019_03_28 NOTHING
% >>>>>>>> 11 
% >>>>>>>> 12 penn_2019_04_13 NOTHING
% 13 tolstoy_2019_01_29 Something - maybe EA to FA?

codes = unique(curfish(ff).spikes.codes);

    for c = 1:length(codes)
        if length(find(curfish(ff).spikes.codes == codes(c))) > fewestNumberofSpikes

            spiketimes = curfish(ff).spikes.times(curfish(ff).spikes.codes == codes(c));
            tmpEV = iu_sta(spiketimes, [], curfish(ff).error_vel, curfish(ff).fs, windowwidth);
            tmpEA = iu_sta(spiketimes, [], curfish(ff).error_acc, curfish(ff).fs, windowwidth);
            tmpFA = iu_sta(spiketimes, [], curfish(ff).fish_acc, curfish(ff).fs, windowwidth);

            if ~exist('evOUT', 'var')
                evOUT = tmpEV;
                eaOUT = tmpEA;
                faOUT = tmpFA;
            else
                evOUT(end+1) = tmpEV;
                eaOUT(end+1) = tmpEA;
                faOUT(end+1) = tmpFA;
            end
        end
    end
end

%%

figure(1); clf; 

for nn = 1:length(evOUT)
    ax(1)=subplot(231); hold on; 
        plot(evOUT(nn).time,evOUT(nn).MEAN);
        xline(0); title('Error Velocity')
    ax(2)=subplot(232); hold on; 
        plot(eaOUT(nn).time,eaOUT(nn).MEAN);
        xline(0); title('Error Acceleration')
        % plot(out(nn).time,out(nn).randMEAN); 
    ax(3)=subplot(233); hold on; 
        plot(faOUT(nn).time,faOUT(nn).MEAN);
        xline(0); title('Fish Acceleration')

    ax(4)=subplot(234); hold on;
        plot(evOUT(nn).time, evOUT(nn).Pval); 
    ax(5)=subplot(235); hold on;
        plot(eaOUT(nn).time, eaOUT(nn).Pval); 
    ax(6)=subplot(236); hold on;
        plot(faOUT(nn).time, faOUT(nn).Pval); 
end

linkaxes(ax,'x')

set(ax(4),"YScale","log"); yline(0.0001);
set(ax(5),"YScale","log"); yline(0.0001);
set(ax(6),"YScale","log"); yline(0.0001);

legend(ax(1),num2str(codes))

% clear codes cc c ff nn spiketimes tmp windowwidth fewestNumberofSpikes evOUT faOUT