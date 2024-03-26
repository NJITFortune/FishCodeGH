function [evOUT, faOUT] = iu_getAllstas(curfish, fishNo) 

% load finalIsmaildata2024.mat

windowwidth = 2;
fewestNumberofSpikes = 2000;

for ff = fishNo
% 1 3 5 -8 -10 
codes = unique(curfish(ff).spikes.codes);

    for c = 1:length(codes)
        if length(find(curfish(ff).spikes.codes == codes(c))) > fewestNumberofSpikes

            spiketimes = curfish(ff).spikes.times(curfish(ff).spikes.codes == codes(c));
            tmpEV = iu_sta(spiketimes, [], curfish(ff).error_vel, curfish(ff).fs, windowwidth);
            tmpFA = iu_sta(spiketimes, [], curfish(ff).fish_acc, curfish(ff).fs, windowwidth);

            if ~exist('evOUT', 'var')
                evOUT = tmpEV;
                faOUT = tmpFA;
            else
                evOUT(end+1) = tmpEV;
                faOUT(end+1) = tmpFA;
            end
        end
    end
end

%%

figure(1); clf; 

for nn = 1:length(evOUT)
    ax(1)=subplot(221); hold on; 
        plot(evOUT(nn).time,evOUT(nn).MEAN);
        xline(0);
        % plot(out(nn).time,out(nn).randMEAN); 
    ax(2)=subplot(222); hold on; 
        plot(faOUT(nn).time,faOUT(nn).MEAN);
        xline(0);

    ax(3)=subplot(223); hold on;
        plot(evOUT(nn).time, evOUT(nn).Pval); 
    ax(4)=subplot(224); hold on;
        plot(faOUT(nn).time, faOUT(nn).Pval); 
end

linkaxes(ax,'x')

set(ax(3),"YScale","log"); yline(0.0001);
set(ax(4),"YScale","log"); yline(0.0001);

legend(ax(1),num2str(codes))

% clear codes cc c ff nn spiketimes tmp windowwidth fewestNumberofSpikes evOUT faOUT