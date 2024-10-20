% u_velocityDeepDive

% 0.1 10 100 1000 10000
% 9-3, 9-4, 3-1, 3-2, 3-3, 3-4, 3-5, 3-6, 6-1, 8-1


fishNum = 8;
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 1);
signal = curfish(fishNum).error_vel;
sig2 = curfish(fishNum).fish_acc;
tim = curfish(fishNum).time;
delt = -0.175;

rango = [0.1 1];
[dsi, ~] = u_trackDSIrange(spikes, signal, sig2, tim, delt, rango);
v(1) = dsi.spikes;

rango = [1 10];
[dsi, ~] = u_trackDSIrange(spikes, signal, sig2, tim, delt, rango);
v(2) = dsi.spikes;

rango = [10 100];
[dsi, ~] = u_trackDSIrange(spikes, signal, sig2, tim, delt, rango);
v(3) = dsi.spikes;

rango = [100 1000];
[dsi, ~] = u_trackDSIrange(spikes, signal, sig2, tim, delt, rango);
v(4) = dsi.spikes;

rango = [1000 10000];
[dsi, ~] = u_trackDSIrange(spikes, signal, sig2, tim, delt, rango);
v(5) = dsi.spikes;

%figure(10); semilogx([1 10 100 1000 10000], abs(v), '.-', 'MarkerSize', 12);
figure(10); hold on; semilogx([1 10 100 1000 10000], abs(v), '.-', 'MarkerSize', 12);
%figure(10); hold on; semilogx([1 10 100 1000], abs(v(1:end-1)), '.-', 'MarkerSize', 12);
