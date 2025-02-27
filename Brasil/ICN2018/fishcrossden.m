function [out, fishnum] = fishcrossden(in, idx, idxs)
% Run fishdist or fishdistS first
% e.g. in = fishdist(f, [100 1100])


figure(1); clf; hold on;

numfish = length(in(idx).fish);
for k=1:numfish
    fishnum(k).meandist = [];
    fishnum(k).meandF = [];
    fishnum(k).totpower = [];
    fishnum(k).totabspower = [];
end

if nargin == 2
    idxs = 1:length(in(idx).pair);
end

%% Extract the Cross Spectral Density for every pair
for j = idxs

di = in(idx).pair(j).descartes - mean(in(idx).pair(j).descartes);
    fishnum(in(idx).pair(j).fishnums(1)).meandist(end+1) = mean(in(idx).pair(j).descartes);
    fishnum(in(idx).pair(j).fishnums(2)).meandist(end+1) = mean(in(idx).pair(j).descartes);    
di = di / max(abs(di));                                        

fr = in(idx).pair(j).dF - mean(in(idx).pair(j).dF);
    fishnum(in(idx).pair(j).fishnums(1)).meandF(end+1) = mean(fr);
    fishnum(in(idx).pair(j).fishnums(2)).meandF(end+1) = mean(fr);
fr = fr / max(abs(fr));                    

Fs = median(diff(in(idx).pair(j).sharedtims));

[out(j).p, out(j).w] = cpsd(di(1:20:end), fr(1:20:end), [], [], [], 0.05*Fs); 
    fishnum(in(idx).pair(j).fishnums(1)).totpower(end+1) = sum(real(out(j).p));
    fishnum(in(idx).pair(j).fishnums(2)).totpower(end+1) = sum(real(out(j).p));
    fishnum(in(idx).pair(j).fishnums(1)).totabspower(end+1) = sum(abs(real(out(j).p)));
    fishnum(in(idx).pair(j).fishnums(2)).totabspower(end+1) = sum(abs(real(out(j).p)));
    
    figure(1); plot(out(j).w, real(out(j).p), '-*'); 
    %figure(1+j); clf; hold on; 
    %plot(in(idx).pair(j).sharedtims, di, '*'); 
    %plot(in(idx).pair(j).sharedtims, fr, '*');

end

%% Test hypothesis 1: Distance determines strength of interaction

dd = []; ddpwr = [];

figure(2);   
for k=1:numfish
    subplot(121); title('Distance vs. sum(psd)'); hold on;
    plot(fishnum(k).meandist, fishnum(k).totpower, 'b*');
    subplot(122); title('Distance vs. sum(abs(psd))');hold on;
    plot(fishnum(k).meandist, fishnum(k).totabspower, 'r*', 'MarkerSize', 4);
    for jj = 1:length(fishnum(k).meandist)
        dd(end+1) = fishnum(k).meandist(jj);
        ddpwr(end+1) =  fishnum(k).totabspower(jj);
    end
end
dd 
ddpwr
[~,~,~,~,stats] = regress(dd',ddpwr')




figure(3); hold on; title('By fish sum(psd)');
for k=1:numfish
    plot(k, sum([fishnum(k).totpower]), 'b*', 'MarkerSize', 5);
    plot(k, sum([fishnum(k).totabspower]), 'r*', 'MarkerSize', 5);
    xlim([0, numfish+1]);
end
