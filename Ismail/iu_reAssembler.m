% load mode_data-002.mat

kk = [1,4,7,13,19,26,30,39,45,53,58,66,70];

for j=1:length(kk)
k = kk(j);

curfish(j).spikes = curfish_res{k}.spikes;
curfish(j).spikes_rand = curfish_res{k}.spikes_rand;

curfish(j).time = curfish_res{k}.time;
curfish(j).fs = curfish_res{k}.fs;

    curfish(j).tracking = curfish_res{k}.tracking;

    curfish(j).error_acc = curfish_res{k}.error_acc;
    curfish(j).error_vel = curfish_res{k}.error_vel;
    curfish(j).error_pos = curfish_res{k}.error_pos;
    curfish(j).error_jerk = curfish_res{k}.error_jerk;

    curfish(j).fish_acc = curfish_res{k}.fish_acc;
    curfish(j).fish_vel = curfish_res{k}.fish_vel;
    curfish(j).fish_pos = curfish_res{k}.fish_pos;
    curfish(j).fish_jerk = curfish_res{k}.fish_jerk;

    curfish(j).shuttle_acc = curfish_res{k}.shuttle_acc;
    curfish(j).shuttle_vel = curfish_res{k}.shuttle_vel;
    curfish(j).shuttle_pos = curfish_res{k}.shuttle_pos;

end

% save finalIsmaildata2024.mat curfish