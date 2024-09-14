
fishNum = 9;
unitNum = 4;

errVel = u_velociraptor(curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == unitNum), curfish(fishNum).error_vel, curfish(fishNum).time, -0.8:0.05:0.8, [50 200]);

fishAcc = u_velociraptor(curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == unitNum), curfish(fishNum).fish_acc, curfish(fishNum).time, -0.8:0.05:0.8, [250 500]);


figure; clf; hold on;

plot([errVel.delay], [errVel.fastdsi], 'b', 'LineWidth', 2);
plot([errVel.delay], [errVel.meddsi], 'g', 'LineWidth', 2);
plot([errVel.delay], [errVel.slowdsi], 'c', 'LineWidth', 2);

plot([fishAcc.delay], [fishAcc.fastdsi], 'r', 'LineWidth', 2);
plot([fishAcc.delay], [fishAcc.meddsi], 'y', 'LineWidth', 2);
plot([fishAcc.delay], [fishAcc.slowdsi], 'm', 'LineWidth', 2);

ylim([-0.7 0.7]);

xline(0); yline(0)

text(-0.4, -0.6, ['Fish ' num2str(fishNum) ', unit ' num2str(unitNum)]);
set(gcf, 'renderer', 'painters');