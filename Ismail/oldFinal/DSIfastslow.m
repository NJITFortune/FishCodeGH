function out = DSIfastslow(theseIDXs, neuronsAll, curfish)

% Our favorite numIDX are:
% pospos 51 (9-3), 52 (9-4), 15 (3-1), 16 (3-2), 17 (3-3), (4-6), (8-6)
% negneg 18 (3-4), 19 (3-5), 20 (3-6), 45 (8-3), 46 (8-4)

% posposIDX = [15 16 17 51 52];
% negnegIDX = [18 19 20 45 46];
% allotherIDX = [1 2 3 5 7 8 10 11 12 14 21 22 23 24 25 26 27 28 31 32 33 34 35 37 39 43 44 47 48 49 50 54 56 57 60 66 69 70 71 72 73];

% theseIDXs = negnegIDX;

for j=length(theseIDXs):-1:1

fprintf('This is j %i \n', j)
f = neuronsAll(theseIDXs(j),1);
    evcutoff = neuronsAll(theseIDXs(j),5);
    facutoff = neuronsAll(theseIDXs(j),6);
n = neuronsAll(theseIDXs(j),2);

%% Get DSIs

% This is using FA as the master and EV as the slave
FAslowDSI = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).fish_acc, curfish(f).error_vel, curfish(f).time, [0 facutoff]);
FAfastDSI = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).fish_acc, curfish(f).error_vel, curfish(f).time, [facutoff 1000000]);

% This is using EV as the master and FA as the slave
EVslowDSI = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [0 evcutoff]);
EVfastDSI = u_DSItimeplotRange(curfish(f).spikes.times(curfish(f).spikes.codes == n), curfish(f).error_vel, curfish(f).fish_acc, curfish(f).time, [evcutoff 1000000]);

%% Extract the max/min values

% FA Get max or min SENSORY
tt = find(FAslowDSI.dels < 0);
[~, SEVidx] = max(abs(FAslowDSI.dsi(tt)));
[~, FEVidx] = max(abs(FAfastDSI.dsi(tt)));
    FAmasterFA(j,:) = [f,n, FAslowDSI.dels(SEVidx), FAslowDSI.dsi(SEVidx), FAfastDSI.dels(FEVidx), FAfastDSI.dsi(FEVidx)];

% FA Get max or min MOTOR
tt = find(FAfastDSI.dels > 0);
offset = length(find(FAfastDSI.dels <= 0));
[~, SFAidx] = max(abs(FAslowDSI.dsi2(tt)));
[~, FFAidx] = max(abs(FAfastDSI.dsi2(tt)));
    FAmasterEV(j,:) = [f,n, FAslowDSI.dels(SFAidx+offset), FAslowDSI.dsi2(SFAidx+offset), FAfastDSI.dels(FFAidx), FAfastDSI.dsi2(FFAidx)];

% EV Get max or min SENSORY
tt = find(EVslowDSI.dels < 0);
[~, SEVidx] = max(abs(EVslowDSI.dsi(tt)));
[~, FEVidx] = max(abs(EVfastDSI.dsi(tt)));
    EVmasterEV(j,:) = [f,n, EVslowDSI.dels(SEVidx), EVslowDSI.dsi(SEVidx), EVfastDSI.dels(FEVidx), EVfastDSI.dsi(FEVidx)];

% EV Get max or min MOTOR
tt = find(EVfastDSI.dels > 0);
offset = length(find(EVfastDSI.dels <= 0));
[~, SFAidx] = max(abs(EVslowDSI.dsi2(tt)));
[~, FFAidx] = max(abs(EVfastDSI.dsi2(tt)));
    EVmasterFA(j,:) = [f,n, EVslowDSI.dels(SFAidx+offset), EVslowDSI.dsi2(SFAidx+offset), EVfastDSI.dels(FFAidx), EVfastDSI.dsi2(FFAidx)];


end

out.EVmasterEV = EVmasterEV;
out.EVmasterFA = EVmasterFA;
out.FAmasterEV = FAmasterEV;
out.FAmasterFA = FAmasterFA;

