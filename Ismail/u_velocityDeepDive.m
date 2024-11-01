% u_velocityDeepDive testing ground.

% 0.1 10 100 1000 10000
% 9-3, 9-4, 3-1, 3-2, 3-3, 3-4, 3-5, 3-6, 6-1, 8-1

fishNum = 9;
spikeNum = 4;

% Report velocity and acceleration ranges

tmp = u_signalprep(curfish(fishNum).error_pos); ev = tmp.vel;
tmp = u_signalprep(curfish(fishNum).fish_pos);
fa = tmp.acc;

figure(1); 
    subplot(121); histogram(ev,-10:0.5:10);
    subplot(122); histogram(fa, -100:5:100);

%% Set rangos

spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == spikeNum);
signal = ev;
sig2 = fa;
tim = curfish(fishNum).time;
delt = -0.175;

rangos = [0,1; 1,3; 3,12];


for j=1:length(rangos)

    [dsi, cnts] = u_trackDSIrange(spikes, signal, sig2, tim, delt, rangos(j,:));
    v(j) = dsi.spikes;
    %n(j) = cnts.newsig;

end


%figure(10); semilogx([1 10 100 1000 10000], abs(v), '.-', 'MarkerSize', 12);
figure(10); hold on; plot(1:j, abs(v), '.-', 'MarkerSize', 12);
% figure(11); hold on; plot(1:j, abs(v), '.-', 'MarkerSize', 12);
%figure(10); hold on; semilogx([1 10 100 1000], abs(v(1:end-1)), '.-', 'MarkerSize', 12);
