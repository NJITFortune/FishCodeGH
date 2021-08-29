% Just make the important plots
close all;

out = ismailism(spikes, time, 25, fish_vel, 'Fish Vel');
pause(1);
out = ismailism(spikes, time, 25, fish_acc, 'Fish Acc');
pause(1);
out = ismailism(spikes, time, 25, fish_jerk, 'Fish Jerk');
pause(1);

out = ismailism(spikes, time, 25, error_vel, 'Error Vel');
pause(1);
out = ismailism(spikes, time, 25, error_acc, 'Error Acc');
pause(1);
out = ismailism(spikes, time, 25, error_jerk, 'Error Jerk');
pause(1);
