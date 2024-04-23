% Plot color-coded stimulus


figure(11); clf; 

ax(1)= subplot(311); hold on;
    plot(curfish.time(curfish.tracking==0), curfish.fish_pos(curfish.tracking==0), 'b.')
    plot(curfish.time(curfish.tracking==1), curfish.fish_pos(curfish.tracking==1), 'r.')
    plot(curfish.time(curfish.tracking==2), curfish.fish_pos(curfish.tracking==2), 'k.')
    plot(curfish.time(curfish.tracking==3), curfish.fish_pos(curfish.tracking==3), 'm.')
    title('Fish Position')

ax(2)= subplot(312); hold on;
    plot(curfish.time(curfish.tracking==0), curfish.error_vel(curfish.tracking==0), 'b.')
    plot(curfish.time(curfish.tracking==1), curfish.error_vel(curfish.tracking==1), 'r.')
    plot(curfish.time(curfish.tracking==2), curfish.error_vel(curfish.tracking==2), 'k.')
    plot(curfish.time(curfish.tracking==3), curfish.error_vel(curfish.tracking==3), 'm.')
    title('Error velocity')

ax(3)= subplot(313); hold on;
    plot(curfish.time(curfish.tracking==0), curfish.fish_acc(curfish.tracking==0), 'b.')
    plot(curfish.time(curfish.tracking==1), curfish.fish_acc(curfish.tracking==1), 'r.')
    plot(curfish.time(curfish.tracking==2), curfish.fish_acc(curfish.tracking==2), 'k.')
    plot(curfish.time(curfish.tracking==3), curfish.fish_acc(curfish.tracking==3), 'm.')
    title('Fish Acceleration')

linkaxes(ax, 'x');


