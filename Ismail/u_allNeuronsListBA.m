% This is a listing of all of the neurons for ISMAIL, from file
% ismailCompleatFinal2024.mat
%
%

%% Load data
load /Users/efortune/NotCloudy/ismailCompleatFinal2024.mat

%% Name LUT
fishNames{13} = 'Tolstoy';
fishNames{1} = 'Andre';
fishNames{2} = 'Ankara';
fishNames{3} = 'BammBamm';
fishNames{4} = 'Bent';
fishNames{5} = 'Brown';
fishNames{6} = 'BrownieOne';
fishNames{7} = 'BrownieTwo';
fishNames{8} = 'Bumpy';
fishNames{9} = 'Fin';
fishNames{10} = 'Goldy';
fishNames{11} = 'Hobo';
fishNames{12} = 'Penn';

%% Indices

clear neuronsAll

% andre_2019_04_10, 1439
neuronsAll(1,:) = [1, 1, 1439, 10270]; %%%%  NR*
neuronsAll(2,:) = [1, 2, 1439, 2236]; % NR
neuronsAll(3,:) = [1, 3, 1439, 5557]; % NR
neuronsAll(4,:) = [1, 4, 1439, 1605]; % NR 
neuronsAll(5,:) = [1, 5, 1439, 2857]; % NR
neuronsAll(6,:) = [1, 6, 1439, 849]; % TOO FEW SPIKES

% ankara_2019_01_31, 689
neuronsAll(7,:) = [2, 1, 689, 6851]; % NR*
neuronsAll(8,:) = [2, 2, 689, 8355]; % NR
neuronsAll(9,:) = [2, 3, 689, 1160]; % NR
neuronsAll(10,:) = [2, 4, 689, 14515]; %%%  NR      
neuronsAll(11,:) = [2, 5, 689, 7346]; % NR
neuronsAll(12,:) = [2, 6, 689, 18630]; %%%  NR
neuronsAll(13,:) = [2, 7, 689, 661]; % TOO FEW SPIKES
neuronsAll(14,:) = [2, 8, 689, 5033]; % NR

% bammbamm_2019_04_12, 809
neuronsAll(15,:) = [3, 1, 809, 15627]; %%%% PosCent        PosHi/PosHi More Sensory
neuronsAll(16,:) = [3, 2, 809, 9609]; %%%%% PosIcon        PosHi/NR Velocity neuron
neuronsAll(17,:) = [3, 3, 809, 8538]; %%%%% PosCent        PosHi/PosHi More Sensory
neuronsAll(18,:) = [3, 4, 809, 11327]; %%%% NegIcon/Cent   NegHi/NegHi More Sensory
neuronsAll(19,:) = [3, 5, 809, 10009]; %%%% NegIcon        NegHi/NegHi
neuronsAll(20,:) = [3, 6, 809, 6637]; %%%%% NegIcon/Cent   NegHi/NegHi

% bent_2019_02_26, 1469
neuronsAll(21,:) = [4, 1, 1469, 28860]; %%% NR!!!!!!!!!!!!
neuronsAll(22,:) = [4, 2, 1469, 30154]; %%% PosSens WEAK  WeakPosHi/WeakNegHi
neuronsAll(23,:) = [4, 3, 1469, 9759]; %%%% PosSens       PosHi/NegHi
neuronsAll(24,:) = [4, 4, 1469, 4220]; %%%% PosSens WEAK  PosHi/Weirdness
neuronsAll(25,:) = [4, 5, 1469, 27233]; %%% NR!!!!!!!!!!!!
neuronsAll(26,:) = [4, 6, 1469, 7761]; %%%% PosSens       PosHi, Sensory? Passive fish?

% brown_2018_09_25, 299 - TRACKING Off by a factor of 10
neuronsAll(27,:) = [5, 1, 299, 3600]; % NR
neuronsAll(28,:) = [5, 2, 299, 5271]; %%%%  NR
neuronsAll(29,:) = [5, 3, 299, 1444]; % 
neuronsAll(30,:) = [5, 4, 299, 1909]; % 
neuronsAll(31,:) = [5, 5, 299, 807]; % TOO FEW SPIKES

% brownie_p1_2019_01_26, 539
neuronsAll(31,:) = [6, 1, 539, 2777]; %%%%  NegSens   Sensory NegHi
neuronsAll(32,:) = [6, 2, 539, 3501]; %%%%  NR
neuronsAll(33,:) = [6, 3, 539, 2433]; %%%%  NR   Weakest Sensory NegHi
neuronsAll(34,:) = [6, 4, 539, 4106]; %%%%  NR
neuronsAll(35,:) = [6, 5, 539, 2937]; %%%%  NegSens WEAK 
neuronsAll(36,:) = [6, 6, 539, 1334]; % 
neuronsAll(37,:) = [6, 7, 539, 2597]; %%%%  NR   Weak Sensory NegHi
neuronsAll(38,:) = [6, 8, 539, 516]; % TOO FEW SPIKES

% brownie_p2_2019_01_26, 389
neuronsAll(39,:) = [7, 1, 389, 3847]; %%%% PosCent   Something is going on here
neuronsAll(40,:) = [7, 2, 389, 1055]; % Messy
neuronsAll(41,:) = [7, 3, 389, 277]; % TOO FEW SPIKES
neuronsAll(42,:) = [7, 4, 389, 1072]; % NR

% bumpy_2019_04_03, 1229
neuronsAll(43,:) = [8, 1, 1229, 24303]; %%% Too late, NR Reanalyze %% Limits %%%
neuronsAll(44,:) = [8, 2, 1229, 10599]; % Messy Reanalyze
neuronsAll(45,:) = [8, 3, 1229, 8508]; %%%%   NegIcon FAST ONLY   Something good, probably
neuronsAll(46,:) = [8, 4, 1229, 7867]; %%%%   NegIcon FAST ONLY Weak  % Motor 0 delay Reanalyze
neuronsAll(47,:) = [8, 5, 1229, 12816]; %%%%  PosAccel Iconic Weak  % Pos fast Bias Reanalyze
neuronsAll(48,:) = [8, 6, 1229, 18279]; %%%%  PosAccel Iconic Weak  % Pos fast Bias Reanalyze
neuronsAll(49,:) = [8, 7, 1229, 7954]; %%%%%  PosCent Sens   Pos Fast Motor Reanalyze

% fin_2019_04_14, 1019
neuronsAll(50,:) = [9, 2, 1019, 12079]; % NR
neuronsAll(51,:) = [9, 3, 1019, 5172]; %%%%%%%PosIcon PosHi/PosHi
neuronsAll(52,:) = [9, 4, 1019, 31508]; %%%%%%PosIcon PosHi/PosHi

% goldy_2019_03_28, 599
neuronsAll(53,:) = [10, 1, 599, 1412]; % 
neuronsAll(54,:) = [10, 2, 599, 7218]; % NR
neuronsAll(55,:) = [10, 3, 599, 562]; % TOO FEW SPIKES
neuronsAll(56,:) = [10, 4, 599, 2442]; % Slow
neuronsAll(57,:) = [10, 5, 599, 2357]; % NR
neuronsAll(58,:) = [10, 6, 599, 958]; % TOO FEW SPIKES
neuronsAll(59,:) = [10, 7, 599, 1536]; % 
neuronsAll(60,:) = [10, 8, 599, 5013]; %%%% PosSens   
neuronsAll(61,:) = [10, 9, 599, 1249]; % 

% hobo_2019_04_01, 1019
neuronsAll(62,:) = [11, 1, 1019, 1432]; % 
neuronsAll(63,:) = [11, 2, 1019, 1617]; %%%%  NegSense
neuronsAll(64,:) = [11, 3, 1019, 503]; % TOO FEW SPIKES
neuronsAll(65,:) = [11, 5, 1019, 235]; % TOO FEW SPIKES

% penn_2019_04_13, 269
neuronsAll(66,:) = [12, 1, 269, 4055]; % PosSlow/Pos/Slow
neuronsAll(67,:) = [12, 2, 269, 366]; % TOO FEW SPIKES
neuronsAll(68,:) = [12, 3, 269, 524]; % TOO FEW SPIKES

% tolstoy_2019_01_29, 569
neuronsAll(69,:) = [13, 1, 569, 3666]; % NR*
neuronsAll(70,:) = [13, 2, 569, 28640]; % NR
neuronsAll(71,:) = [13, 3, 569, 13401]; % NR
neuronsAll(72,:) = [13, 4, 569, 11166]; % NR
neuronsAll(73,:) = [13, 5, 569, 13055]; % NR


%% Filter

% Threshold for unit: greater than total 2000 spikes 
    numIDX = find(neuronsAll(4,:) > 2000);


%% STA plot everyone

for j = 1: length(numIDX)

    



end