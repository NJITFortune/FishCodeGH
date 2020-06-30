function out = ritavideoreview(filena, dlc)
% filena is something like '/Volumes/Cgate/Data2019/4_14_2019/individual_trials/trial1509_130hz/Fin_1509_130Hz.mov'
% or 'd:\Users\Eric\Documents\Data\4_14_2019\individual_trials\trial1509_130hz\Fin_1509_130Hz.mov'
% dlc is from loading the appropriate corrected position file - load that before running this script!

v = VideoReader(filena); % Read the filename
Fs = v.FrameRate;
tim = 1/Fs:1/Fs:length(dlc.fishx)/Fs;

% Cycle through the video, plotting every jumptim seconds

jumptim = 0.25;

for j = jumptim:jumptim:(v.Duration-0.1)

    v.CurrentTime = j;
    a = readFrame(v);
    
    figure(1); clf;
    imshow(a);
    hold on;
    text(200, 200, num2str(j), 'FontSize', 36, 'Color', 'r');
    idx = v.CurrentTime*v.FrameRate;
    
    plot(dlc.fishx(idx), dlc.fishy(idx), 'm.', 'MarkerSize', 48);
        plot(dlc.fishx(idx), dlc.fishy(idx), 'w.', 'MarkerSize', 8);
    plot(dlc.shutx(idx), dlc.shuty(idx), 'g.', 'MarkerSize', 48);
        plot(dlc.shutx(idx), dlc.shuty(idx), 'w.', 'MarkerSize', 8);
        
        drawnow;

        figure(2); clf;
        subplot(211); hold on;
            plot(tim, dlc.fishx); 
            plot([j, j], [500, 1000], 'k-');
        subplot(212); hold on;
            plot(tim,dlc.fishy);
            plot([j, j], [0, 300], 'k-');
            
        drawnow;

end

out = 0;