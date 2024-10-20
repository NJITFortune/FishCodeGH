% Step one: Figure out best times, all spikes, all stimuli

fishNum = 9; % 3 POS eVEL / POS fACC neuron
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 3);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.100
% Max DSI = 0.357

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% error_acc plot doesn't quite make sense - peak at 0

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% fish_vel doesn't quite make sense 

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = 0.10
% Max DSI = 0.227


%%%%%%%%%%%%%%
fishNum = 9; % 4 POS eVEL / POS fACC neuron
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 4);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.125
% Max DSI = 0.227

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% error_acc plot doesn't quite make sense - peak at 0

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% fish_vel doesn't quite make sense 

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = 0.075
% Max DSI = 0.197

%%%%%%%%%%%%%%
fishNum = 3; % 1 POS eACC / POS fACC neuron
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 1);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% error_vel doesn't quite make sense 

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.20
% Max DSI = 0.130

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% fish_vel doesn't quite make sense 

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = 0.175
% Max DSI = 0.160

%%%%%%%%%%%%%%
fishNum = 3; % 2 POS eVEL+eACC / POS fACC neuron
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 2);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.025
% Max DSI = 0.234

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.20
% Max DSI = 0.112

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% fish_vel doesn't quite make sense 

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = 0.110
% Max DSI = 0.125

%%%%%%%%%%%%%%
fishNum = 3; % 3 POS eACC / POS fACC neuron
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 3);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% error_vel doesn't quite make sense 

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.15
% Max DSI = 0.101

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% fish_vel doesn't quite make sense 

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = 0.175
% Max DSI = 0.132

%%%%%%%%%%%%%%
fishNum = 3; % 4 NEG eACC / NEG fACC neuron
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 4);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% error_vel doesn't quite make sense 

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.225
% Max DSI = -0.175

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% fish_vel doesn't quite make sense 

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = 0.150
% Max DSI = -0.121


%%%%%%%%%%%%%%
fishNum = 3; % 5 NEG eVEL-eACC / NEG fACC neuron
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 5);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.05
% Max DSI = -0.135

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.225
% Max DSI = -0.155

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% fish_vel doesn't quite make sense 

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = 0.125
% Max DSI = -0.105



%%%%%%%%%%%%%%
fishNum = 3; % 6 NEG eACC / NEG fACC neuron
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 6);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Hmmmm

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.250
% Max DSI = -0.127

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% fish_vel doesn't quite make sense 

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = 0.075
% Max DSI = -0.12


%%%%%%%%%%%%%%
fishNum = 4; % 2 POS eVEL / NR
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 2);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.225
% Max DSI = 0.092

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Not sense

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% fish_vel doesn't quite make sense 

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% NR

%%%%%%%%%%%%%%
fishNum = 4; % 3 POS eVEL-eACC / Weak POS fVEL and Neg fACC
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 3);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.05
% Max DSI = 0.103

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.325
% Max DSI = 0.082

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = 0.125
% Max DSI = 0.071

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = 0.275
% Max DSI = -0.048


%%%%%%%%%%%%%%
fishNum = 4; % 4 POS eVEL / Weak NEG fACC
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 4);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.150
% Max DSI = 0.085

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Nonsense

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = 0.125
% Max DSI = 0.071

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = 0.200
% Max DSI = -0.029

%%%%%%%%%%%%%%
fishNum = 4; % 6 POS eVEL / Weak NEG fACC
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 6);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.125
% Max DSI = 0.116

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.35
% Max DSI = 0.091

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% -

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = 0.300
% Max DSI = -0.059

%%%%%%%%%%%%%%
fishNum = 6; % 1 NEG eVEL / No motor
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 1);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.05
% Max DSI = -0.119

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% -

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% -

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% NR

%%%%%%%%%%%%%%
fishNum = 6; % 5 NEG eVEL / no motor
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 5);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.075
% Max DSI = -0.108

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.200
% Max DSI = -0.068

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% -

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% -

%%%%%%%%%%%%%%
fishNum = 6; % 7 NEG eVEL / no motor
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 7);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.200
% Max DSI = -0.088

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% -

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% -

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% -

%%%%%%%%%%%%%%
fishNum = 8; % 1 Weak
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 1);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Centered at zero, positive 0.05

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.175
% Max DSI = 0.033

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% -

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% -

%%%%%%%%%%%%%%
fishNum = 8; % 3 Weak
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 3);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Centered at zero, positive 0.05

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.200
% Max DSI = 0.044

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% -

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% -


%%%%%%%%%%%%%%
fishNum = 11; % 2 NEG eVEL
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 2);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Centered at zero, -0.210

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.125
% Max DSI = -0.113

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% -

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Weak


%%%%%%%%%%%%%%
fishNum = 12; % 2 POS eVEL- NEG eACC / NEG fACC
spikes = curfish(fishNum).spikes.times(curfish(fishNum).spikes.codes == 1);
sig = curfish(fishNum).error_vel;
tim = curfish(fishNum).time;

foo = u_DSItimeplot(spikes, sig, tim);

plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.125
% Max DSI = 0.066

sig = curfish(fishNum).error_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = -0.225
% Max DSI = -0.087

sig = curfish(fishNum).fish_vel;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% -

sig = curfish(fishNum).fish_acc;
foo = u_DSItimeplot(spikes, sig, tim);
plot(foo.dels, foo.dsi, foo.dels, foo.rdsi);

% Best delay = 0.075
% Max DSI = -0.075


